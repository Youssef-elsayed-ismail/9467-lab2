if ["$#" -ne 3];
then  echo "missing argument"
exit 1
fi

dir="$1"
malicious="$2"
interval="$3"

mkdir -p "$dir" "$malicious"
EXTENSIONS=("exe" "bat" "vbs" "scr" "ps1")
KEYWORDS=("virus" "malware" "worm" "trojan" "ransomware")
scan_dir(){
local deleted_any=0

for file in "$dir"/*;
do
[-f "$file" ] || continue
filename=$(basename "$file")
bad=0
if [["$filename"==*.*]];
then 
ext="${filename##*.}"
for bad_ext in "${EXTENSIONS[@]}";
do 
if ["$ext"="$bad_ext"];
then 
bad=1
break
fi
done 
fi
if [$bad -eq 0] ;
then for word in "${KEYWORD[@]}"; do
if grep -qi "$word" "$file" 2>/dev/null;
then 
bad=1
break
fi
done 
fi
if [$bad -eq 1] ;
then
echo "$filename is malicious"
cp "$file" "$malicious/$filename"
rm "$file" 
deleted_any=1
fi
done
return $deleted_any
}


