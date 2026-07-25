# [使用 PkgPub](https://app.niggergo.work/purejoy/pkgpub/use)

> 使用通过 PkgPub 部署的依赖

在 maven 仓库列表中添加 [*回忆溢出工作组*](https://oom-wg.dev/) 的仓库以使用其依赖

## 引入依赖源 [#引入依赖源]

<Tabs groupId="gradle-script" items="['Groovy', 'Kotlin']">
  <Tab>
    ```groovy
    pluginManagement {
        repositories {
            maven {
                url 'https://oom-maven.sawahara.host'
                content {
                    includeGroupAndSubgroups 'ren.shiror'
                    includeGroupAndSubgroups 'sbs.fvvlang'
                    includeGroupAndSubgroups 'work.niggergo'
                    includeGroupAndSubgroups 'dev.oom-wg'
                    includeGroupAndSubgroups 'dev.oom_wg'
                }
            }
        }
    }
    dependencyResolutionManagement {
        repositories {
            maven {
                url 'https://oom-maven.sawahara.host'
                content {
                    includeGroupAndSubgroups 'ren.shiror'
                    includeGroupAndSubgroups 'sbs.fvvlang'
                    includeGroupAndSubgroups 'work.niggergo'
                    includeGroupAndSubgroups 'dev.oom-wg'
                    includeGroupAndSubgroups 'dev.oom_wg'
                }
            }
        }
    }
    ```
  </Tab>

  <Tab>
    ```kotlin
    pluginManagement {
        repositories {
            maven("https://oom-maven.sawahara.host") {
                content {
                    includeGroupAndSubgroups("ren.shiror")
                    includeGroupAndSubgroups("sbs.fvvlang")
                    includeGroupAndSubgroups("work.niggergo")
                    includeGroupAndSubgroups("dev.oom-wg")
                    includeGroupAndSubgroups("dev.oom_wg")
                }
            }
        }
    }
    dependencyResolutionManagement {
        repositories {
            maven("https://oom-maven.sawahara.host") {
                content {
                    includeGroupAndSubgroups("ren.shiror")
                    includeGroupAndSubgroups("sbs.fvvlang")
                    includeGroupAndSubgroups("work.niggergo")
                    includeGroupAndSubgroups("dev.oom-wg")
                    includeGroupAndSubgroups("dev.oom_wg")
                }
            }
        }
    }
    ```
  </Tab>
</Tabs>

### 镜像源 [#镜像源]

目前有如下源:

* `https://oom-maven.sawahara.host`: EdgeOne Pages (全球，包括中国大陆)
* `https://maven.oom-wg.dev`: GitHub Pages
* `https://raw.githubusercontent.com/OOM-WG/PureJoy/maven`: GitHub

---

> [**Page Index**] <https://app.niggergo.work/llms.txt> | [**Full Content**] <https://app.niggergo.work/llms-full.txt>