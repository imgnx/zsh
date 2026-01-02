#!/opt/homebrew/bin/bash
# shellcheck shell=bash



#! NOTICE: Don't use this to add directories to your path.

#! Use `add2path` for that!
# add2path $XDG_CONFIG_HOME/emacs/bin
# add2path /usr/local/Cellar/postgresql@16/16.10/bin
# add2path "/Applications/MuseScore 4.app/Contents/MacOS"

# ? Replaced with Octals (ANSI Color Codes)
# if [[ ! -d $ZDOTDIR/node_modules/chalk ]]; then
# 	npm install --save chalk
# 	echo "Installing chalk..."
# fi

mapfile -t imgnx < <(
	node <<'EOF'
import chalk from "chalk";
import { execSync } from "node:child_process";

const arr1 = process.env.PATH?.split(":"),
	  arr2 = [],
      set = new Set();

// let counter = 0;
for (const el of arr1) {
    try {
		let realpath=execSync(`realpath ${el} 2>/dev/null`, { encoding: "UTF-8" }).trim();
		// counter = counter + 1;
		if (!set.has(realpath)) {
			// console.log(counter, set.has(realpath));
			// console.log(JSON.stringify([...set]));
			// console.log("\x1b[32mIncluding: \x1b[0m" + el);
			// eliminates already-included paths..
			arr2.push("\x1b[32m" + el + "\x1b[0m")
			set.add(realpath);
		} else {
			// console.log("\x1b[33mDuplicate: \x1b[0m" + el);
			arr2.push("\x1b[33m" + el + "\x1b[0m")
		}
    } catch(err) {
		arr2.push("\x1b[31m" + el + "\x1b[0m")
		// console.log("\x1b[31mError: \x1b[0m" + el + "\n" + err.message + "\n");
    }
}
const PATH=[...set].join(":"); 
// console.log("Final set:", set);
console.log(arr2.join(":"));
console.log(PATH);
EOF
)

# export PATH="${imgnx[2]}"
# echo -e "Current PATH: ${imgnx[0]}"
# echo -e "\033[32mNew PATH: \033[0m${imgnx[1]}"

# export PATH="${imgnx[1]}"

echo "${imgnx[1]}"
