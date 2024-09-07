index_file=$1
component=$2
component_name_capitalized=$(echo "$component" | awk '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) tolower(substr($i,2))}1')

echo -e "import React, { ReactElement } from 'react';\n" > $index_file
echo "export const $component_name_capitalized = (): ReactElement => {" >> $index_file
echo "  return <>React component created under the name of $component_name_capitalized</>" >> $index_file
echo "}" >> $index_file