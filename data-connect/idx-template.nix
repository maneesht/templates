/*

rm -rf ./test && \
idx-template \
  /home/user/community-templates/dataconnect \
  --output-dir /home/user/community-templates/template-test -a '{}'

*/
{pkgs, platform ? "web", appType ? "blank", ... }: {
  packages = [
    pkgs.nodejs_20
    pkgs.git
  ];

  bootstrap = let 
    platformPrefix = if platform == "web" then "js" else "flutter";
    sample = "${platformPrefix}-${appType}";
    in ''
    ${
    if sample == "js-quickstart" then "git clone -b mtewani/idx-updates --single-branch https://github.com/firebase/quickstart-js test-dir --no-checkout
    cd test-dir
    git sparse-checkout init --cone
    git sparse-checkout set dataconnect
    git checkout
    cp -r dataconnect \"$out\"
    " else if sample == "flutter-quickstart" then "
    git clone -b mtewani/idx-git-updates --single-branch https://github.com/firebase/quickstart-flutter test-dir --no-checkout
    cd test-dir
    git sparse-checkout init --cone
    git sparse-checkout set data_connect
    git checkout
    cp -r data_connect \"$out\"
    " else "
    mkdir -p \"$out\"/.idx
    "}
    chmod -R u+w "$out"
    ${if appType == "quickstart" then "
    cp ${./setup-idx.sh} \"$out\"/setup-idx.sh
    cd \"$out\"
    chmod +x ./setup-idx.sh
    ./setup-idx.sh ${platform}
    " else ""}
    ${
    if sample == "flutter-blank" then "cp -r ${./flutter}/dev.nix \"$out\"/.idx/dev.nix"
      else if sample == "js-blank" then "cp ${./nextjs-blank}/dev.nix \"$out\"/.idx/dev.nix"
      else ""
    }
    
    ${
      if sample == "js-blank" then "cp -r ${./nextjs-blank}/* \"$out\""
      else if sample == "flutter-blank" then "cp -r ${./flutter-blank}/* \"$out\""
      else if sample == "flutter-movie" then "cp -r ${./flutter-movie}/* \"$out\""
      else ""
    }
    ${
      if sample == "flutter-blank" then "cp ${./flutter}/Caddyfile \"$out\"/" else ""
    }
    ${
      if sample == "flutter-blank" then "cp ${./flutter}/error_handler.dart \"$out\"/lib/" else ""
    }
  '';
}
