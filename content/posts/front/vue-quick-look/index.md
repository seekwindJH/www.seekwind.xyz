---
title: "Vue 速览手册"
date: 2021-12-21T13:58:00+08:00
draft: false
tags:
    - vue
categories:
    - front-end
---

<!--more-->

## 1. 创建项目

### 2. Vue-Cli方式创建Vue Project

安装Vue使用如下npm全局命令。

```bash
npm install vue vue-cli vue-route -g
```

随后，使用vue-cli工具创建一个项目。

```bash
vue init webpack vue-demo
vue create vue-demo # 这个命令也是可以的
```

关于其在命令行的配置，保持默认即可，也可以自行修改。

执行如下命令即可启动项目或打包项目。

```bash
npm run dev
npm run build
```

### 2. 原生的前端项目

上面提及的是依赖于Webpack、Vue-Cli等工具创建的Vue项目。为了方便并加深对Vue的理解，我们在学习时使用原生Vue项目，而在实际开发项目时使用Vue工程。

```html
<script src="https://cdn.staticfile.org/vue/2.2.2/vue.js"></script>
```

## 2. 一个简单的Vue页面

这个页面十分简单，旨在帮助读者快速了解Vue的书写风格。

```html
<!DOCTYPE html>
<html lang="zh-CN">

<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <script src="https://cdn.staticfile.org/vue/2.2.2/vue.js"></script>
    <title>Hello Vue</title>
</head>

<body>
    <div id="app">
        <!-- 双大括号包裹变量 -->
        <h1> site: {{site}} </h1>
        <h1> url: {{url}} </h1>
        <h1> {{details()}} </h1>
    </div>
    <script type="text/javascript">
        // 声明一个vm模型
        var vm = new Vue({
            el: '#app', // 挂载点
            data: { // 数据对象
                site: "追风の物语",
                url: "www.seekwind.xyz",
            },
            methods: { // 方法，其返回值将传给方法的调用者
                details: function() {
                    return this.site + " - 愿你所追寻的风，都能如期而至"
                }
            }
        })
    </script>
</body>

</html>
```

## 3. 常用的Vue API

此处只列举常用的Vue API指令，具体使用方法请详见[Vue官网-模板语法](https://cn.vuejs.org/v2/guide/syntax.html)或者[runoob教程-Vue模板语法](https://www.runoob.com/vue2/vue-template-syntax.html)。

| 指令                  | 作用                                                                                                                  |
| --------------------- | --------------------------------------------------------------------------------------------------------------------- |
| v-html                | 绑定标签内html                                                                                                        |
| v-text                | 绑定标签内纯文本                                                                                                      |
| v-bind                | v-bind可以与任何标签属性搭配，使得属性值被绑定。**v-bind是响应式的**。简写为:                                         |
| v-on                  | 绑定监听器，可以使用v-on:submit.prevent来阻止默认提交行为。简写为@                                                    |
| v-model               | 在input标签中使用，实现数据**双向绑定**，即标签状态改变会使得vue中相应data的值改变。有.lazy、.number、.trim三种修饰符 |
| \|过滤器              | vm的filter域中声明一个过滤器，可以完成诸如将一句话首字母大写等功能。                                                  |
| v-if v-else v-else-if | 条件渲染语句。false即不渲染，dom中没有该元素                                                                          |
| v-show                | 与v-if不同，false即display: none，dom中依然保留该元素                                                                 |
| v-for                 | 循环，两种用法。v-for="value in object", v-for="(value, key) in object"                                               |

关于v-on绑定的事件，实际上有更多的事件修饰符，如下所示。
* .stop 阻止冒泡
* .prevent 阻止默认行为
* .capture 阻止捕获
* .self 只监听触发该元素的事件，不接收冒泡事件
* .once 只触发一次
* .left 左键事件
* .right 右键事件
* .middle 中间滚轮事件

进一步的，针对v-on:keyup键盘事件，我们只需要追加keyCode即可完成对指定按键的监听。keyCode还可以串联呢。

1. 字母和数字键的键码值(keyCode)

| 按键 | 键码 | 按键 | 键码 | 按键 | 键码 | 按键 | 键码 |
| ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- |
| A    | 65   | J    | 74   | S    | 83   | 1    | 49   |
| B    | 66   | K    | 75   | T    | 84   | 2    | 50   |
| C    | 67   | L    | 76   | U    | 85   | 3    | 51   |
| D    | 68   | M    | 77   | V    | 86   | 4    | 52   |
| E    | 69   | N    | 78   | W    | 87   | 5    | 53   |
| F    | 70   | O    | 79   | X    | 88   | 6    | 54   |
| G    | 71   | P    | 80   | Y    | 89   | 7    | 55   |
| H    | 72   | Q    | 81   | Z    | 90   | 8    | 56   |
| I    | 73   | R    | 82   | 0    | 48   | 9    | 57   |

2. 数字键盘上的键的键码值(keyCode)

| 按键 | 键码 | 按键  | 键码 |
| ---- | ---- | ----- | ---- |
| 0    | 96   | 8     | 104  |
| 1    | 97   | 9     | 105  |
| 2    | 98   | *     | 106  |
| 3    | 99   | +     | 107  |
| 4    | 100  | Enter | 108  |
| 5    | 101  | -     | 109  |
| 6    | 102  | .     | 110  |
| 7    | 103  | /     | 111  |

3. 功能键键码值(keyCode)

| 按键 | 键码 | 按键 | 键码 |
| ---- | ---- | ---- | ---- |
| F1   | 112  | F7   | 118  |
| F2   | 113  | F8   | 119  |
| F3   | 114  | F9   | 120  |
| F4   | 115  | F10  | 121  |
| F5   | 116  | F11  | 122  |
| F6   | 117  | F12  | 123  |

4. 控制键键码值(keyCode)

| 按键      | 键码 | 按键       | 键码 | 按键        | 键码 | 按键 | 键码 |
| --------- | ---- | ---------- | ---- | ----------- | ---- | ---- | ---- |
| BackSpace | 8    | Esc        | 27   | Right Arrow | 39   | -_   | 189  |
| Tab       | 9    | Spacebar   | 32   | Dw Arrow    | 40   | .>   | 190  |
| Clear     | 12   | Page Up    | 33   | Insert      | 45   | /?   | 191  |
| Enter     | 13   | Page Down  | 34   | Delete      | 46   | `~   | 192  |
| Shift     | 16   | End        | 35   | Num Lock    | 144  | [{   | 219  |
| Control   | 17   | Home       | 36   | ;:          | 186  | \|   | 220  |
| Alt       | 18   | Left Arrow | 37   | =+          | 187  | ]}   | 221  |
| Cape Lock | 20   | Up Arrow   | 38   | ,<          | 188  | '"   | 222  |

5. 多媒体键码值(keyCode)

| 按键   | 键码 |
| ------ | ---- |
| 音量加 | 175  |
| 音量减 | 174  |
| 停止   | 179  |
| 静音   | 173  |
| 浏览器 | 172  |
| 邮件   | 180  |
| 搜索   | 170  |
| 收藏   | 171  |

某些按键Vue还提供了别名。
* .enter
* .tab
* .delete (同时捕获**删除**和**退格**键)
* .esc
* .space
* .up
* .down
* .left
* .right
* .ctrl
* .alt
* .shift
* .meta

## 4. Vue对象的常见属性

| 属性     | 作用                                                                                                                           |
| -------- | ------------------------------------------------------------------------------------------------------------------------------ |
| data     | 简单的数据变量                                                                                                                 |
| computed | 计算属性，相当于一种需要计算的数据变量。但是它**基于缓存**，重新渲染时并不会重新计算。可以定义getter和setter方法，来实现响应式 |
| methods  | 可以完成与computed类似的功能，区别是每次重新渲染都会重新计算值。它也可以用来当作事件监听器的回调方法。                         |
| watch    | 监听属性。当被监听的数据发生变化时，会调用相应的方法。                                                                         |
| class    | 有三种绑定方式。1. 在v-bind:class中直接书写js对象的形式。2. 在v-bind:class中书写实现定义的对象。3. 在v-style中声明内联样式     |

## 5. Vue Component

首先是**注册**。分为全局注册和局部注册。

```js
Vue.component(
    'my-component',
    template: '<h1>This is My Component.</h1>',
    data: function() {
        return {} // 建议以工厂函数形式，为每个Component创建独立的数据域
    }
)
```

```js
new Vue({
  el: '#app',
  components: {
    'my-component': template: '<h1>This is My Component.</h1>'
  }
})
```

其次，在组件中，可以通过props属性来接收父组件的数据。

```html
<div id="app">
    <div>
      <input v-model="parentMsg">
      <br>
      <child v-bind:message="parentMsg"></child>
    </div>
</div>
 
<script>
Vue.component('child', {
  props: ['message'],
  template: '<span>{{ message }}</span>'
})
new Vue({
  el: '#app',
  data: {
    parentMsg: '父组件内容'
  }
})
</script>
```

props属性可以声明其类型，类型可以是String、Number、Boolean、Array、Object、Date、Function、Symbol。

```js
props: {
    // 基础的类型检查 (`null` 和 `undefined` 会通过任何类型验证)
    propA: Number,
    // 多个可能的类型
    propB: [String, Number],
    // 必填的字符串
    propC: {
      type: String,
      required: true
    },
    // 带有默认值的数字
    propD: {
      type: Number,
      default: 100
    },
    // 带有默认值的对象
    propE: {
      type: Object,
      // 对象或数组默认值必须从一个工厂函数获取
      default: function () {
        return { message: 'hello' }
      }
    },
    // 自定义验证函数
    propF: {
      validator: function (value) {
        // 这个值必须匹配下列字符串中的一个
        return ['success', 'warning', 'danger'].indexOf(value) !== -1
      }
    }
}
```

自定义事件很简单，使用v-on:myEvent绑定自定义事件，然后再用this.$emit('myEvent')方法触发自定义事件，this指代被触发元素自身。自定义事件过多时，可使用.native来调用原生事件。

自定义组件的v-model默认利用value的prop和input事件。

## 6. 自定义指令

全局注册。

```html
<div id="app">
    <p>页面载入时，input 元素自动获取焦点：</p>
    <input v-focus>
</div>
 
<script>
// 注册一个全局自定义指令 v-focus
Vue.directive('focus', {
  // 当绑定元素插入到 DOM 中。
  inserted: function (el) {
    // 聚焦元素
    el.focus()
  }
})
// 创建根实例
new Vue({
  el: '#app'
})
</script>
```

局部注册。

```html
<div id="app">
  <p>页面载入时，input 元素自动获取焦点：</p>
  <input v-focus>
</div>
 
<script>
// 创建根实例
new Vue({
  el: '#app',
  directives: {
    // 注册一个局部的自定义指令 v-focus
    focus: {
      // 指令的定义
      inserted: function (el) {
        // 聚焦元素
        el.focus()
      }
    }
  }
})
</script>
```

inserted被称为钩子函数。常见的钩子函数有：
* **bind**: 只调用一次，指令第一次绑定到元素时调用，用这个钩子函数可以定义一个在绑定时执行一次的初始化动作。
* **inserted**: 被绑定元素插入父节点时调用（父节点存在即可调用，不必存在于 document 中）。
* **update**: 被绑定元素所在的模板更新时调用，而不论绑定值是否变化。通过比较更新前后的绑定值，可以忽略不必要的模板更新（详细的钩子函数参数见下）。
* **componentUpdated**: 被绑定元素所在模板完成一次更新周期时调用。
* **unbind**: 只调用一次， 指令与元素解绑时调用。

钩子函数的参数除了el外，还有：
* **el**: 指令所绑定的元素，可以用来直接操作 DOM 。
* **binding**: 一个对象，包含以下属性：
  * *name*: 指令名，不包括 v- 前缀。
  * *value*: 指令的绑定值， 例如： v-my-directive="1 + 1", value 的值是 2。
  * *oldValue*: 指令绑定的前一个值，仅在 update 和 componentUpdated 钩子中可用。无论值是否改变都可用。
  * *expression*: 绑定值的表达式或变量名。 例如 v-my-directive="1 + 1" ， expression 的值是 "1 + 1"。
  * *arg:* 传给指令的参数。例如 v-my-directive:foo， arg 的值是 "foo"。
  * *modifiers*: 一个包含修饰符的对象。 例如： v-my-directive.foo.bar, 修饰符对象 modifiers 的值是 { foo: true, bar: true }。
* **vnode**: Vue 编译生成的虚拟节点。
* **oldVnode**: 上一个虚拟节点，仅在 update 和 componentUpdated 钩子中可用。

## 7. Vue Router

使用Vue Router之前，需要引入cdn。
```html
<script src="https://unpkg.com/vue-router/dist/vue-router.js"></script>
```

或者npm安装。
```bash
npm install vue-router -g
```

一个简单的vue-router案例如下。

```html
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <script src="https://cdn.staticfile.org/vue/2.2.2/vue.js"></script>
    <script src="https://unpkg.com/vue-router/dist/vue-router.js"></script>
    <title>Hello Vue</title>
</head>
<body>
    <div id="app">
        <p>
            <router-link to="/foo">Go to Foo</router-link>
            <router-link to="/bar">Go to Bar</router-link>
        </p>
        <router-view></router-view>
    </div>

    <script>
        const Foo = { template: '<div>foo</div>' }
        const Bar = { template: '<div>bar</div>' }

        const routes = [
            { path: '/foo', component: Foo },
            { path: '/bar', component: Bar }
        ]

        const router = new VueRouter({
            routes // （缩写）相当于 routes: routes
        })

        const app = new Vue({
            router
        }).$mount('#app')
    </script>
</body>
</html>
```

## 8. Vue Ajax（Axios）

Vue推荐使用Axios与vue-resource来完成异步请求。

```html
<script src="https://unpkg.com/axios/dist/axios.min.js"></script>
<script src="https://cdn.staticfile.org/vue-resource/1.5.1/vue-resource.min.js"></script>
```

