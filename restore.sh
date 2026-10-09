
if [ "$#" -ne 2 ]; then
    echo "Invalid>"
    exit 1
fi

DIR="$1"
MALICIOUS_DIR="$2"

while true; do
     
 shopt -s nullglob
  files=("$MALICIOUS_DIR"/*)
   shopt -u nullglob

   
 if [ ${#files[@]} -eq 0 ]; then
      echo "No malicious files."
      exit 0
  fi

  echo ""
  echo "Choose a file:"
   count=1
 for f in "${files[@]}"; do
   echo "$count: $(basename "$f")"
        count=$((count + 1))
    done

 read -rp "> " choice

    
 if ! [[ "$choice" =~ ^[0-9]+$ ]] || [ "$choice" -lt 1 ] || [ "$choice" -ge "$count" ]; then
        echo "Invalid choice."
        continue
    fi

    selected="${files[$((choice - 1))]}"
    filename=$(basename "$selected")

    echo ""
    echo "For $filename:"
    echo "1: Restore this file back into dir (it was a false positive)"
    echo "2: Permanently delete this file from malicious_dir (it was genuinely malicious)"
    echo "3: Go back"
    read -rp "> " opt

    case "$opt" in
        1)
            mv "$selected" "$DIR/$filename"
            echo "Restored $filename to $DIR."
            ;;
        2)
            rm "$selected"
            echo "$filename permanently deleted."
            ;;
        3)
            continue
            ;;
        *)
            echo "Invalid option."
            ;;
    esac
done
