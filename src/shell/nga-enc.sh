# NGA SDK - AW Enc by Sakitin(GitHub@GunRain 酷安@芙洛洛 bilibili@安音咲汀)

# GitHub link: https://github.com/GunRain/NGA-SDK

for file in "$@"; do
  [ -f "$file" ] || exit 1
  echo -n "$(echo -en "set +x; \`echo -n '$(echo -n 'eval' | awk '{for(i=length;i!=0;i--)x=x substr($0,i,1)} END{print x}')' | awk '{for(i=length;i!=0;i--)x=x substr(\$0,i,1)} END{print x}'\` \\\\\n\"\$(\n  {\n    for char in $(echo -n "\`echo -n '$(echo -n 'eval' | awk '{for(i=length;i!=0;i--)x=x substr($0,i,1)} END{print x}')' | awk '{for(i=length;i!=0;i--)x=x substr(\$0,i,1)} END{print x}'\` \"\$(echo -n \"$(echo -n 'set +x; for cmd in unalias set unset eval echo base64 cat zcat bzcat; do unset $cmd; unalias $cmd 2>/dev/null; unset $cmd; unalias $cmd 2>/dev/null; done; set +x' | gzip -c9 | base64 -w 0)\" | base64 -d | zcat)\"; \`echo -n '$(echo -n 'eval' | awk '{for(i=length;i!=0;i--)x=x substr($0,i,1)} END{print x}')' | awk '{for(i=length;i!=0;i--)x=x substr(\$0,i,1)} END{print x}'\` \"\$(echo -n \"`cat "$file" | gzip -c9 | base64 -w 0`\" | base64 -d | zcat)"\" | awk '{for (i = 1; i <= length($0); i++) {char = substr($0, i, 1); print (char == " " ? " \\" : char "\\")}}' | sed '$ s/\\$//' | bzip2 -c9 | gzip -c9 | base64 -w 0 | sed "s/./& /g"); do\n      echo -n \$char\n    done\n  } \\\\\n  | \`echo -n '$(echo -n 'base64' | awk '{for(i=length;i!=0;i--)x=x substr($0,i,1)} END{print x}')' | awk '{for(i=length;i!=0;i--)x=x substr(\$0,i,1)} END{print x}'\` -d \\\\\n  | cat \\\\\n  | zcat \\\\\n  | bzcat\n)\"")" > "$file"
done

exit 0