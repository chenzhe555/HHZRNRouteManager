const pathSep = require('path').sep;
// 通过node.js path模块获取路径分割符
function createCustomModuleIdFactory() {
    const projectRootPath = __dirname; // node.js内置变量，获取项目路径，为了后面去掉路径前缀
    return path => {
        let customName = '';
        if (path.indexOf('node_modules' + pathSep + 'react-native' + pathSep + 'Libraries' + pathSep) > 0) {
            // 这里是去除路径中的'node_modules/react-native/Libraries/‘之前（包括）的字符串(没有这个的话安卓会报错:Requiring unknown module "InitializeCore"等等，查看了下js文件，发现引入了此文件__r("InitializeCore.js");干脆node_module下的都去掉算了)
            customName = path.substr(path.lastIndexOf(pathSep) + 1);
        } else if (path.indexOf(projectRootPath) == 0) {
            // 去掉路径前缀，因为里面带了当前打包机器的信息，不能保证唯一
            customName = path.substr(projectRootPath.length + 1);
        }

        // 将所有正斜杠换成 _ (考虑分隔符有\\和/的情况)
        const regExp = pathSep === '\\' ? new RegExp('\\\\', 'gm') : new RegExp(pathSep, 'gm');
        customName = customName.replace(regExp, '_');
        return customName;
    };
}


module.exports = {
    serializer: {
        createModuleIdFactory: createCustomModuleIdFactory
    }
};
