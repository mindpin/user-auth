用户验证组件，支持MINDPIN和本地两种方式

# 使用说明

gemfile 引入
```
gem "user-auth",
    :git => "git://github.com/mindpin/user-auth.git",
    :tag => "0.0.3"
```

使用方法详情查看 https://github.com/mindpin/knowledge-camp/wiki/%E7%94%A8%E6%88%B7%E9%AA%8C%E8%AF%81-Gem#%E4%BD%BF%E7%94%A8%E6%96%B9%E5%BC%8F

# 查看例子工程
```
  git clone git://github.com/mindpin/user-auth.git

  # 查看 mindpin_mode 的例子工程
  cd mindpin_mode_sample
  # 编辑 mongoid.yml
  vi config/mongoid.yml
  rails s

  # 查看 local_store_mode 的例子工程
  cd local_store_mode_sample
  # 编辑 mongoid.yml
  vi config/mongoid.yml
  rails s
```
