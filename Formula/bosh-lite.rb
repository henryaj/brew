class VagrantInstalledRequirement < Requirement
  fatal true
  cask "vagrant"

  satisfy(:build_env => false) { system "which", "vagrant" }

  def message
    "Vagrant must be installed."
  end
end

class BoshCliInstalledRequirement < Requirement

end

class BoshLite < Formula
  desc "A lite development env for BOSH"
  homepage "https://github.com/cloudfoundry/bosh-lite"
  url "https://github.com/cloudfoundry/bosh-lite/archive/9000.129.0.tar.gz"
  version "9000.129.0"
  sha256 "54eebf3dac423ba7fa84e99ef74efc69a7873f496bce0bc791db4f20d9a9acf3"

  # depends_on :ruby
  depends_on VagrantInstalledRequirement

  def install
    system "vagrant", "up", "--provider=virtualbox"
    system "sudo", "./bin/add-route"
    system "sudo", "./bin/enable-container-internet"
  end

  def vagrant_path

  end

  def caveats
%q{Your bosh-lite is now running. Please install the BOSH CLI with:

    `gem install bosh_cli`

and target your BOSH Director with:

    `bosh target 192.168.50.4`

The credentials are admin/admin.

Always use the VirtualBox app to suspend the bosh-lite VM. Putting your machine
to sleep without first suspending the VM can corrupt it.
}
  end

  test do
    # test that bosh-lite VM is responding
    system "curl", "192.168.50.4:25555"
  end
end
