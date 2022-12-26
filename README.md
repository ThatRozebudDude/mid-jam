sup bitches, check out my cool new game!

you now need the haxelib `newgrounds` so install that

speaking of newgrounds, i basically stole the code for `Newgrounds.hx` from [eric](https://github.com/MasterEric) so thanks for that buddy!

if you are compiling to desktop, everything should work fine, but if you want to compile to html5, you're gonna need to do some extra stuff
this is because of the newgrounds integration (which is html5 exclusive) requires an api and encryption key to work, which i did not include for obvious reasons

you have 2 options:

1) make a file in `/source` and call it `NGKeys.hx`, and copy & paste this into it

```haxe
package;

class NGKeys
{
    public static final api = "";
    public static final encryption = "";
}
```

or

2) you could go into `Newgrounds.hx` and delete all the parts that reference `NGKeys` to remove the ng stuff

ALSO IF YOU MOD THIS FOR ANY REASON LET ME KNOW!!!! i wanna see it!