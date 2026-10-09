
if [ "$#" -ne 3 ]; then
echo "Usage: $0 <dir> <malicious_dir> <interval-secs>"
exit 1
fi
DIR="$1"
MALICIOUS_DIR="$2"
INTERVAL="$3"
mkdir -p "$DIR" "$MALICIOUS_DIR"
EXTENSIONS="exe bat vbs scr ps1"
KEYWORDS="virus trojan malware worm ransomware"
scan_dir() {
for file in "$DIR"/*; do
[ -f "$file" ] || continue
filename=$(basename "$file"); is_bad=0
case "$filename" in
*.*) ext="${filename##*.}"
for bad_ext in $EXTENSIONS; do
if [ "$ext" = "$bad_ext" ]; then is_bad=1; break; fi
done ;;
esac
if [ "$is_bad" -eq 0 ]; then
for word in $KEYWORDS; do
if grep -qi "$word" "$file" 2>/dev/null; then is_bad=1; break; fi
done
fi
if [ "$is_bad" -eq 1 ]; then
echo "$filename is malicious and it is DELETED"
cp "$file" "$MALICIOUS_DIR/$filename"; rm "$file"
fi
done
}
scan_dir
ls -l "$DIR" > directory-info.last
while true; do
sleep "$INTERVAL"
ls -l "$DIR" > directory-info.new
if ! diff -q directory-info.last directory-info.new >/dev/null 2>&1; then
scan_dir
ls -l "$DIR" > directory-info.last
fi
done
