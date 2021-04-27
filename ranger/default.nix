{ pkgs }:
with pkgs;
python3Packages.buildPythonApplication rec {
  name = "ranger";

  meta = {
    description = "File manager with minimalistic curses interface";
    homepage = http://ranger.nongnu.org/;
    license = pkgs.lib.licenses.gpl3;
    platforms = pkgs.lib.platforms.unix;
  };

  src = fetchGit {
    url = "https://github.com/ranger/ranger";
    rev = "07bad7490a5dc019a58740b0323377437ab1e5da";
    #sha256 = "0xsz8nl1k8p1hxc3p6p4x85wn2kwkj1hi5xsiapbfkbxhhg1kq78";
  };

  checkInputs = with python3Packages; [ pytest astroid pylint ];
  propagatedBuildInputs = [ file
                            w3m
                            highlight
                            bat
                            atool
                            mediainfo
                            #odt2txt
                            xsv
                            jq
                            binutils
                            hexd
                            poppler_utils
                            #(python37.withPackages (ps: with ps; [jupytext pandoc setuptools]))
                          ];

  checkPhase = ''
    #py.test tests
  '';

  preConfigure = ''
    cp ${scope} ranger/data/scope.sh
    substituteInPlace ranger/data/scope.sh \
      --replace "/bin/echo" "echo"

    cp ${rifle} ranger/config/rifle.conf

    substituteInPlace ranger/__init__.py \
      --replace "DEFAULT_PAGER = 'less'" "DEFAULT_PAGER = '${pkgs.lib.getBin less}/bin/less'"
    for i in ranger/config/rc.conf doc/config/rc.conf ; do
      substituteInPlace $i --replace /usr/share $out/share
    done

    substituteInPlace ranger/config/rc.conf \
      --replace "set preview_script ~/.config/ranger/scope.sh" "set preview_script $out/share/doc/ranger/config/scope.sh"
    substituteInPlace ranger/ext/img_display.py \
      --replace /usr/lib/w3m ${w3m}/libexec/w3m
    # give image previews out of the box when building with w3m
    substituteInPlace ranger/config/rc.conf \
      --replace "set preview_images false" "set preview_images true" \
  '';

  scope = ./scope.sh;
  rifle = ./rifle.conf;
}
