
if [ "$#" -ne 2 ]; then
echo "Usage: $0 <dir> <malicious_dir>"
exit 1
fi
DIR="$1"; MALICIOUS_DIR="$2"
touch .whitelist
while true; do
set -- "$MALICIOUS_DIR"/*
if [ ! -e "$1" ]; then
echo "No malicious files to review."
exit 0
fi
echo ""; echo "Choose a file:"
count=1
for f in "$MALICIOUS_DIR"/*; do
[ -e "$f" ] || continue
echo "$count: $(basename "$f")"
count=$((count + 1))
done
printf "> "; read choice
case "$choice" in
''|*[!0-9]*) echo "Invalid choice."; continue ;;
esac
if [ "$choice" -lt 1 ] || [ "$choice" -ge "$count" ]; then
echo "Invalid choice."; continue
fi
i=1; selected=""
for f in "$MALICIOUS_DIR"/*; do
if [ "$i" -eq "$choice" ]; then selected="$f"; break; fi
i=$((i + 1))
done
filename=$(basename "$selected")
echo ""; echo "For $filename:"
echo "1: Restore this file back into dir (it was a false positive)"
echo "2: Permanently delete this file from malicious_dir (it was genuinely malicious)"
echo "3: Go back"
printf "> "; read opt
case "$opt" in
1)
grep -qx "$filename" .whitelist 2>/dev/null || echo "$filename" >> .whitelist
mv "$selected" "$DIR/$filename"; echo "Restored $filename to $DIR." ;;
2) rm "$selected"; echo "$filename permanently deleted." ;;
3) continue ;;
*) echo "Invalid option." ;;
esac
done
