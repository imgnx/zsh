#!/bin/zsh
#shellcheck disable=all

# NOTICE: Don't use this to add directories to your path. Use .zshrc for that.
# add2path $XDG_CONFIG_HOME/emacs/bin
# add2path /usr/local/Cellar/postgresql@16/16.10/bin
# add2path "/Applications/MuseScore 4.app/Contents/MacOS"

npm install --save chalk > /dev/null;

imgnx=$(node<<'EOF'
import chalk from "chalk";
import { execSync } from "node:child_process";

console.log(chalk);

const arr1=process.env.PATH?.split(":"),
      arr2=[];

arr1.forEach(el => {
    try {
	let realpath=execSync(`realpath ${el}`, { encoding: "UTF-8" });
	if (!arr2.includes(realpath)) {
	    // eliminates already-included paths..
	    arr2.push(realpath.trim());
	}
    } catch(err) {
	console.error(chalk.red(err.message));
    }
});
const PATH=arr2.join(":").trim();
console.log(PATH);
EOF
    )

echo "imgnx: $imgnx"
