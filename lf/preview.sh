#! /usr/bin/env bash

set -euxo pipefail

[ -z "${1:-}" ] && echo "usage: $0 <image> [width] [height]" && exit 1

FILE="${1}"
WIDTH="${2:-$(tput cols)}"
HEIGHT="${3:-$(tput lines)}"

WIDTH="$(( WIDTH - 3 ))"
HEIGHT="$(( HEIGHT - 3 ))"

[ -L "${FILE}" ] && FILE="$(readlink "$FILE")"

# Main procedure
function main() {
	# Display title and border
	local filename="${FILE/$PWD\//}"
	printf "\e[38;5;243m%*s\e[0m\n" $(( (${#filename} + WIDTH) / 2)) "$filename"
	printf "\e[38;5;238m%${WIDTH}s\e[0m\n" | tr ' ' '-'

	# Use the right tool for the extension
	case "${FILE}" in
		*.tar|*.tgz|*.xz) tar tvf "${FILE}"; return $?;;
		*.deb) ar -tv "${FILE}"; return $?;;
		*.zip) als -lqq "${FILE}" || unzip -l "${FILE}"; return $?;;
		*.rar) unrar l -- "${FILE}"; return $?;;
		*.7z|*.dmg|*.gz) 7z l -- "${FILE}" && return $?;;
		*.bzip|*.bzip2|*.bp|*.bz2) als "${FILE}" && return $?;;

		*.jpg|*.JPG|*.png|*.PNG) view_image || view_binary;;
		*.ans|*.ANS) view_ansi && return $?;;
		*.json) jq -C . "${FILE}" && return $?;;
		*.md) glow -s dark -w "${WIDTH}" "${FILE}" && return $?;;
		*.plist) plutil -p "${FILE}" && return $?;;
		*.txt) view_sourcecode && return $?;;
		*.xml) xmlstarlet fo -s 2 "${FILE}" | view_sourcecode - && return $?;;
	esac

	# Use the right tool for the mimetype label
	case "$(file -b --mime-type "${FILE}")" in
		image/*) view_image || view_binary;;
		video/*|audio/*) view_multimedia || view_binary;;
		application/pdf) view_pdf || view_binary;;
		application/epub*) view_epub || view_binary;;
		application/gzip|application-x-xz) tar tvf "${FILE}";;
		application/x-sqlite*) view_sqlite || view_binary;;
		application/x-terminfo|text/x-bytecode.python) view_binary;;
		application/vnd.*-officedocument*|application/vnd.*.opendocument*)
			view_opendocument || view_binary;;
		application/octet-stream|application/x-*-binary|application/x-*executable)
			view_binary;;

		*) view_sourcecode;;
	esac
	return $?
}

# View binary hexyl/heksa/hexdump
function view_binary() {
	local len="$(( WIDTH * HEIGHT ))"

	hexyl -n "$len" --border none "$FILE" || \
		heksa -l "$len" "$FILE" || \
		hexdump -n "$len" -C "$FILE"

	return $?
}

# View source-code with bat/pygmentize/highlight/cat
function view_sourcecode() {
	local input="${1:-$FILE}"

	BAT_CONFIG_PATH='' bat "${input}" \
			--theme=OneHalfDark --color=always --paging=never --tabs=2 --wrap=auto \
			--style=plain --terminal-width "${WIDTH}" --line-range :"${HEIGHT}" || \
		pygmentize -P tabsize=2 -O style=monokai -f console256 -g "${input}" || \
		highlight -t 2 -s rdark -O xterm256 --force "${input}" || \
		cat "${input}"

	return $?
}

# View images in terminal with chafa/timg/catimg/imgcat
function view_image() {
	local input="${1:-$FILE}"

	viu -sb -w "$WIDTH" "$input" || \
	catimg -r 2 -H "$HEIGHT" "$input" || \
	chafa -s "$WIDTH"x"$HEIGHT" "$input" || \

	local result=$?
	if hash exiv2 2>/dev/null; then
		echo
		exiv2 -qu "$FILE"
	fi

	return $result
}

# Viw multimedia metadata with mediainfo/id3ted/exiftool/id3info
function view_multimedia() {
	mediainfo "${FILE}" | sed 's/ *:/:/g' || \
		id3ted -L "${FILE}" || \
		exiftool "${FILE}" || \
		id3info "${FILE}"

	return $?
}

# View Opendocument with pandoc/odt2txt
function view_opendocument() {
	if ! hash odt2txt 2>/dev/null; then
		return 1
	elif ! hash pandoc 2>/dev/null; then
		odt2txt "${FILE}"
	elif ! hash glow 2>/dev/null; then
		pandoc "${FILE}" --to=markdown || odt2txt "${FILE}"
	else
		glow -s dark -w "${WIDTH}" \
			<(pandoc "${FILE}" --to=markdown || odt2txt "${FILE}")
	fi
	return $?
}

# View PDF with pdftoppm or pdftotext
function view_pdf() {
	if hash pdftoppm 2>/dev/null; then
		 pdftoppm -f 1 -l 1 -scale-to-x 1024 -scale-to-y -1 \
				-singlefile -jpeg -tiffcompression jpeg -- "${FILE}" \
			| view_image -
		hash pdfinfo 2>/dev/null && pdfinfo "$FILE"
	elif hash pdftotext 2>/dev/null; then
		pdftotext -raw -l 10 -nopgbrk -q -- "${FILE}" -
	fi
	return $?
}

# Find and view cover image with tar and xmlstarlet
function view_epub() {
	if hash xmlstarlet 2>/dev/null; then
		opf_path="$(tar xOf "$FILE" 'META-INF/container.xml' \
			| xmlstarlet sel -t -v '/_:container/_:rootfiles/_:rootfile/@full-path')"

		opf="$(tar xOf "$FILE" "$opf_path")"

		cover_name="$(echo "$opf" | xmlstarlet \
			sel -t -v '/_:package/_:metadata/_:meta[@name="cover"]/@content')"

		echo "$opf" | xmlstarlet sel \
				-t -v "/_:package/_:manifest/_:item[@id='$cover_name']/@href" \
			| xargs -I'{}' tar xOf "$FILE" "$(dirname "$opf_path")/{}" \
			| view_image -
	else
		{
			tar xOf "$FILE" 'OEBPS/assets/cover.*' || \
				tar xOf "$FILE" '*/cover.png' || \
				tar xOf "$FILE" 'cover.png'
		} | view_image -
	fi

	return $?
}

# List SQLite file tables and dump schema
function view_sqlite() {
	echo -e "# \e[1;37mTABLES\e[0m\n"
	sqlite3 "$FILE" ".tables"
	echo -e "\n# \e[1;37mSCHEMA\e[0m\n"
	sqlite3 "$FILE" ".schema"
	return $?
}

# View ANSI as PNG with ansilove
function view_ansi() {
	local tmpdir="${TMPDIR:-/tmp}"
	local tmppng="$tmpdir/lf-preview-ansi-$$.png"

	ansilove -o "$tmppng" "$FILE" 1>/dev/null && \
		chafa -s "$WIDTH"x "$tmppng" && \
		rm -f -- "$tmppng"

	return $?
}

main
