#!/usr/bin/awk -f
{
    if ($0 ~ /^(\w+)(.\[\w+\])?:/) {
        split ($0, line, ":");
        character=line[1];
        phrase=tolower(gensub(/[^a-zA-Z0-9 ]/, "", "g", line[2]));
        count=split(phrase, words, " ");
        for (i = 0; ++i <= count;) {
            print  character " " words[i]
        }
    }
}
