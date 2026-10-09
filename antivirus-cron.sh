
if [ "$#" -ne 2 ]; then
echo "Usage: $0 <dir> <malicious_dir>"
exit 1
fi
DIR="$1"; MALICIOUS_DIR="$2"
mkdir -p "$DIR" "$MALICIOUS_DIR"
touch .whitelist
EXTENSIONS="exe bat vbs scr ps1"
KEYWORDS="virus trojan malware worm ransomware"
for file in "$DIR"/*; do
[ -f "$file" ] || continue
filename=$(basename "$file"); is_bad=0
grep -qx "$filename" .whitelist 2>/dev/null && continue
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
