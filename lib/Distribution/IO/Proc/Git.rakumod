use Distribution::IO;

# This targets a LOCAL git path. An additional role could provide access to non-local remotes
role Distribution::IO::Proc::Git does Distribution::IO {
    my sub run-git(*@cmd, :%env = %*ENV, :$cwd, Bool :$bin) {
        my $proc = $*DISTRO.is-win
            ?? run('cmd', '/c', 'git', |@cmd, :out, :err, :$bin, :$cwd, :%env)
            !! run('git', |@cmd, :out, :err, :$bin, :$cwd, :%env);
        my $out = |$proc.out.slurp-rest(:$bin);
        my $err = |$proc.err.slurp-rest(:$bin);
        $ = $proc.out.close unless $err;
        $ = $proc.err.close;

        %( :$out, :$err )
    }

    method ls-files {
        state @paths = run-git('ls-files', :cwd($.prefix))<out>.lines;
    }

    method slurp-rest($name-path, Bool :$bin) {
        run-git('show', "HEAD:$name-path", :$bin, :cwd($.prefix))<out>;
    }
}
