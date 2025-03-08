#=================================================================================================================
# Copyright (c) 2023-present Anne Sakitin (Tianwan Ayana).                                                       =
#                                                                                                                =
# Part of the NGA project.                                                                                       =
# Licensed under the F2DLPR License.                                                                             =
#                                                                                                                =
# YOU MAY NOT USE THIS FILE EXCEPT IN COMPLIANCE WITH THE LICENSE.                                               =
# Provided "AS IS", WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND,                                                =
# unless required by applicable law or agreed to in writing.                                                     =
#                                                                                                                =
# For full information about the NGA project, please visit: http://app.niggergo.work.                            =
# For full information about the F2DLPR License terms and policies, please visit: http://license.fileto.download.    =
#=================================================================================================================

for file in "$@"; do
  [ -f "$file" ] || exit 1
  echo -n "$(echo -en "set +x; \$(echo -n '$(echo -n 'eval' | awk '{for(i=length;i!=0;i--)x=x substr($0,i,1)} END{print x}')' | awk '{for(i=length;i!=0;i--)x=x substr(\$0,i,1)} END{print x}') \\\\\n\"\$(\n  {\n    for char in $(echo -n "\`echo -n '$(echo -n 'eval' | awk '{for(i=length;i!=0;i--)x=x substr($0,i,1)} END{print x}')' | awk '{for(i=length;i!=0;i--)x=x substr(\$0,i,1)} END{print x}'\` \"\$(echo -n \"$(echo -n "set +x; for cmd in unalias set unset eval echo base64 cat zcat bzcat; do unset \$cmd; unalias \$cmd 2>/dev/null; unset \$cmd; unalias \$cmd 2>/dev/null; done; set +x" | gzip -c9 | base64 -w 0)\" | base64 -d | zcat)\"; \`echo -n '$(echo -n 'eval' | awk '{for(i=length;i!=0;i--)x=x substr($0,i,1)} END{print x}')' | awk '{for(i=length;i!=0;i--)x=x substr(\$0,i,1)} END{print x}'\` \"\$(echo -n \"$(gzip -c9 "$file" | base64 -w 0)\" | base64 -d | zcat)"\" | awk '{for (i = 1; i <= length($0); i++) {char = substr($0, i, 1); print (char == " " ? " \\" : char "\\")}}' | sed '$ s/\\$//' | bzip2 -c9 | gzip -c9 | base64 -w 0 | sed "s/./& /g"); do\n      echo -n \$char\n    done\n  } \\\\\n  | \`echo -n '$(echo -n 'base64' | awk '{for(i=length;i!=0;i--)x=x substr($0,i,1)} END{print x}')' | awk '{for(i=length;i!=0;i--)x=x substr(\$0,i,1)} END{print x}'\` -d \\\\\n  | cat \\\\\n  | zcat \\\\\n  | bzcat\n)\"")" > "$file"
done

exit 0