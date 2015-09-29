class Infer < Formula
  desc "Infer is a static analysis tool that can analyze Java, Obj-C, and C"
  homepage "https://fbinfer.com/"
  url "https://github.com/facebook/infer/releases/download/v0.3.0/infer-osx-v0.3.0.tar.xz"
  sha256 "cfd17c647098baff2875f3ff4db994f2ee02e7b5577cde5fe59ee21ec57a2d44"

  def install
    libexec.install Dir["*"]
    bin.install_symlink Dir["#{libexec}/infer/infer/bin/infer"]
  end

  test do
    expected = <<-EOS.undent
      Starting analysis (Infer version v0.2.0)
      Analysis done

      1 file analyzed


      #{libexec}/infer/examples/Hello.java:4: error: NULL_DEREFERENCE
        object s last assigned on line 3 could be null and is dereferenced at line 4
    EOS
    actual = shell_output("#{bin}/infer -- javac #{libexec}/infer/examples/Hello.java").chomp
    assert_equal expected, actual

    expected = <<-EOS.undent
      Starting analysis (Infer version v0.2.0)
      Analysis done

      1 file analyzed


      #{libexec}/infer/examples/Hello.m:10: error: NULL_DEREFERENCE
        pointer hello last assigned on line 9 could be null and is dereferenced at line 10, column 12
    EOS
    actual = shell_output("#{bin}/infer -- clang -c #{libexec}/infer/examples/Hello.m").chomp
    assert_equal expected, actual

    expected = <<-EOS.undent
      Starting analysis (Infer version v0.2.0)
      Analysis done

      1 file analyzed


      #{libexec}/infer/examples/hello.c:5: error: NULL_DEREFERENCE
        pointer s last assigned on line 4 could be null and is dereferenced at line 5, column 3
    EOS
    actual = shell_output("#{bin}/infer -- gcc -c #{libexec}/infer/examples/hello.c").chomp
    assert_equal expected, actual
  end
end
