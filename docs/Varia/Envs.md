# Environment Configuration Record

!!! info
    为了有效缓解重装系统之后配环境的痛苦，我决定在这里写下我的环境配置纪实。
    
    什么？配环境不痛苦？那你给我配。

## 脚本

忍不了了！所以写了个配环境的脚本！

??? "Makefile"
    ```Makefile
    install:
    sudo apt update
    sudo apt install python3 pip autoconf automake gcc g++ flex bison ccache help2man libtool gtkwave perl-doc
    sudo apt install build-essential gcc-riscv64-linux-gnu binutils-riscv64-linux-gnu qemu-user gdb-multiarch pkg-config device-tree-compiler
    sudo apt install npm nodejs zsh llvm llvm-dev libreadline-dev
    download: install
    git clone https://git.zju.edu.cn/zju-sys/sys1/sys1-sp24.git
    git submodule update --init sys1-sp24/repo/riscv-isa-cosim
    git submodule update --init sys1-sp24/repo/riscv-pk
    git submodule update --init sys1-sp24/repo/riscv-openocd
    git submodule update --init sys1-sp24/repo/sys-project
    git submodule update --init sys1-sp24/repo/verilator
    cd sys1-sp24/repo/sys-project && git checkout other
    cd sys1-sp24/repo && make verilator
    cd sys1-sp24/repo && make spike
    cd sys1-sp24/repo && sudo make pk
    cd sys1-sp24/repo && make openocd
    cd /usr/local && sudo mkdir riscv64-unknown-elf && sudo mkdir riscv64-unknown-elf/bin && sudo cp riscv64-linux-gnu/bin/pk riscv64-unknown-elf/bin
    cd ~ && mkdir package
    cd ~/package && wget https://github.com/neovim/neovim/releases/download/v0.9.5/nvim-linux64.tar.gz
    $ curl --proto '=https' --tlsv1.2 https://sh.rustup.rs -sSf | sh
    cd ~/package && tar xzvf nvim-linux64.tar.gz
    cd ~ && sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    cd ~ && git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/half-life
    ```

## WSL

### 安装

我不说了，假定所有人都会。

删除本版本的 WSL：`wsl --unregister Ubuntu-20.04` 后边跟的是版本号，使用 `wsl --list` 就能看见了。

### `zsh`

安装 `zsh` 并设置为默认 shell：
```shell
sudo apt install zsh
cat /etc/shells
chsh -s /bin/zsh
```

使用 `oh-my-zsh` 美化 `zsh`：
```shell
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/half-life
```

使用 vim 打开 `~/.zshrc`，修改 `ZSH_THEME` 为 `ZSH_THEME="half-life"`：
```shell
vim ~/.zshrc
ZSH_THEME="half-life"       // 这步是在 vim 里边写入的
```

配置插件：
```shell
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting 
```

还要修改 `~/.zshrc`，在 `plugins` 里边加入 `zsh-autosuggestions` 和 `zsh-syntax-highlighting`：
```shell
plugins=(git zsh-autosuggestions zsh-syntax-highlighting z)
```

### vim

原版的 vim 不太好看，而且功能也有限，虽然现在不太用 vim 了，但是还是好看一点比较好，这里选择安装 lunarvim：

安装步骤大概分几步：安装 lunarvim 的所有依赖，改环境变量，安装 lunarvim，改环境变量。环境变量千万别改错，改回去稍微费点劲。

```shell
wget https://github.com/neovim/neovim/releases/download/v0.9.5/nvim-linux64.tar.gz
tar xzvf nvim-linux64.tar.gz
vim ~/.zshrc
export PATH=$PATH:~/nvim-linux64/bin    // 这步是在 vim 里边写入的
source ~/.zshrc
sudo apt install pip npm nodejs ripgrep
LV_BRANCH='release-1.3/neovim-0.9' bash <(curl -s https://raw.githubusercontent.com/LunarVim/LunarVim/release-1.3/neovim-0.9/utils/installer/install.sh)
nvim ~/.zshrc
export PATH=$PATH:~/.local/bin          // 这步是在 vim 里边写入的
source ~/.zshrc
```

开始享受 lunarvim 吧！

### 计算机系统相关

首先需要安装依赖：
```shell
sudo apt-get install git perl python3 make autoconf g++ flex bison ccache autoconf automake libtool help2man
```

其实就是按照系统 I 的文档开抄：

```Shell
cd sys1-sp24/repo
git submodule update --init verilator riscv-isa-cosim riscv-openocd risv-pk
sudo make verilator
sudo make spike
sudo make pk
sudo make openocd
```

说是使用 `git submodule`，其实就是 `git clone https://github.com/verilator/verilator.git`

??? info "makefile 的内容"

    makefile 的内容放在下边：
    
    ```Make
    DIR_BUILD		:= $(CURDIR)/build
    DIR_PATCH		:= $(CURDIR)/patch
    DIR_UPSTREAM	:= $(CURDIR)/sys-project
    
    # compile for the ip folder
    SPIKE_DIR		:= $(CURDIR)/riscv-isa-cosim
    SPIKE_SRC		:= $(shell find $(SPIKE_DIR) -name "*.cc" -o -name "*.h" -o -name "*.c")
    SPIKE_LIB		:= $(addprefix $(SPIKE_BUILD)/,libcosim.a libriscv.a libdisasm.a libsoftfloat.a libfesvr.a libfdt.a)
    SPIKE_INCLUDE	:= $(SPIKE_DIR) $(SPIKE_DIR)/cosim $(SPIKE_DIR)/fdt $(SPIKE_DIR)/fesvr \
                       $(SPIKE_DIR)/riscv $(SPIKE_DIR)/softfloat $(SPIKE_BUILD)
    IP_BUILD		:= $(DIR_BUILD)/ip
    DIR_COSIM_IP	:= $(DIR_UPSTREAM)/ip
    
    export LD_LIBRARY_PATH=$(IP_BUILD)
    $(IP_BUILD)/patch:
        mkdir -p $(IP_BUILD)
        cd $(SPIKE_DIR) ; git apply $(DIR_PATCH)/riscv-isa-cosim/*
        touch $(IP_BUILD)/patch
    
    $(IP_BUILD)/Makefile:
        mkdir -p $(IP_BUILD)
        cd $(IP_BUILD); $(SPIKE_DIR)/configure --prefix=$(DIR_COSIM_IP)
    
    ip_gen:$(SPIKE_SRC) $(IP_BUILD)/Makefile $(IP_BUILD)/patch
        mkdir -p $(DIR_COSIM_IP)
        make -C $(IP_BUILD) -j$(shell nproc) $(notdir $(SPIKE_LIB))
        make -C $(IP_BUILD) install
    
    #compiler for verilator
    VLT_DIR 	:= $(CURDIR)/verilator
    VLT_BUILD	:= $(DIR_BUILD)/verilator
    $(VLT_BUILD)/Makefile:
        mkdir -p $(VLT_BUILD)
        cd $(VLT_DIR); autoconf
        cd $(VLT_BUILD); $(VLT_DIR)/configure 
    
    verilator:$(VLT_BUILD)/Makefile $(VLT_DIR)
        make -C $(VLT_BUILD) -j$(shell nproc)
        sudo make -C $(VLT_BUILD) install
        verilator --version
    
    #compiler for opensbi
    OPENSBI_DIR		:=	$(CURDIR)/opensbi
    OPENSBI_BUILD	:=  $(DIR_BUILD)/opensbi
    FW_JUMP_BUILD	:=  $(OPENSBI_BUILD)/platform/generic/firmware/fw_jump.bin $(OPENSBI_BUILD)/platform/generic/firmware/fw_jump.elf
    FW_JUMP			:=  $(DIR_UPSTREAM)/spike/fw_jump.bin $(DIR_UPSTREAM)/spike/fw_jump.elf
    
    $(OPENSBI_BUILD)/patch:
        mkdir -p $(OPENSBI_BUILD)
        cd $(OPENSBI_DIR); git apply $(DIR_PATCH)/opensbi/*
        touch $(OPENSBI_BUILD)/patch
    
    $(FW_JUMP_BUILD):$(OPENSBI_SRC) $(OPENSBI_BUILD)/patch
        make -C $(OPENSBI_DIR) O=$(OPENSBI_BUILD) \
            CROSS_COMPILE=riscv64-linux-gnu- \
            PLATFORM=generic
    
    $(FW_JUMP):$(FW_JUMP_BUILD)
        cp $(FW_JUMP_BUILD) $(DIR_UPSTREAM)/spike/
    
    fw_jump:$(FW_JUMP)
    
    #compiler for spike
    SPIKE_BUILD	:= $(DIR_BUILD)/spike
    
    spike:$(SPIKE_DIR)
        mkdir -p $(SPIKE_BUILD)
        cd $(SPIKE_BUILD) ; $(SPIKE_DIR)/configure
        make -C $(SPIKE_BUILD) -j$(shell nproc)
        sudo make -C $(SPIKE_BUILD) install
    
    #compiler for openocd
    OPENOCD_DIR 	:= $(CURDIR)/riscv-openocd
    OPENOCD_BUILD	:= $(DIR_BUILD)/openocd
    
    openocd:$(OPENOCD_DIR)
        mkdir -p $(OPENOCD_BUILD)
        cd $(OPENOCD_DIR); ./bootstrap;
        cd $(OPENOCD_BUILD); $(OPENOCD_DIR)/configure
        make -C $(OPENOCD_BUILD) -j$(shell nproc)
        sudo make -C $(OPENOCD_BUILD) install
        openocd --version
    
    PK_DIR	:=	$(CURDIR)/riscv-pk
    PK_BUILD:= 	$(DIR_BUILD)/riscv-pk
    
    pk:$(PK_DIR)
        mkdir -p $(PK_BUILD)
        cd $(PK_BUILD); $(PK_DIR)/configure --host=riscv64-linux-gnu
        cd $(PK_BUILD); make -j$(nproc)
        cd $(PK_BUILD); make install
    ```

### gcc 版本切换

首先添加 ppa 源：

```Shell
sudo add-apt-repository ppa:ubuntu-toolchain-r/test
sudo -E add-apt-repository ppa:ubuntu-toolchain-r/test
sudo apt-get update
```

下面利用 `update-alternatives` 进行 gcc 版本切换：

```Shell
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-13 70 --slave /usr/bin/g++ g++ /usr/bin/g++-13
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-10 60 --slave /usr/bin/g++ g++ /usr/bin/g++-11
sudo update-alternatives --config gcc
```

之后按照提示选择 gcc 版本即可。

添加不了就拉倒，手动装就好了，但是可能用不了几个版本了，因为这样默认的 gcc 就是 gcc-13 了，但是仍然不建议手动编译安装，因为会出现坑爹的情况。

```Shell
mkdir package && cd package
wget http://ftp.gnu.org/gnu/gcc/gcc-13.1.0/gcc-13.1.0.tar.gz
tar xf gcc-13.1.0.tar.gz
cd gcc-13.1.0/
./contrib/download_prerequisites
mkdir build && cd build
../configure -enable-checking=release -enable-languages=c,c++ -disable-multilib
sudo make -j8           // 给我编译半小时！
sudo make install
```

## Rust

```Shell
curl --proto '=https' --tlsv1.2 https://sh.rustup.rs -sSf | sh
. "$HOME/.cargo/env"
```