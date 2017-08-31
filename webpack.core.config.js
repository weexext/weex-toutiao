const pathTo = require('path');
const fs = require('fs-extra');
const webpack = require('webpack');

const entry = {};
const weexEntry = {};
const vueWebTemp = 'temp';
const hasPluginInstalled = fs.existsSync('./web/plugin.js');
var isWin = /^win/.test(process.platform);

function getEntryFileContent(entryPath, vueFilePath) {
	const relativePath = pathTo.relative(pathTo.join(entryPath, '../'), vueFilePath);
	let contents = '';
	if(hasPluginInstalled) {
		const plugindir = pathTo.resolve('./web/plugin.js');
		contents = 'require(\'' + plugindir + '\') \n';
	}
	if(isWin) {
		relativePath.replace(/\\/g, '\\\\');
	}
	contents += 'var App = require(\'' + relativePath + '\')\n';
	contents += 'App.el = \'#root\'\n';
	contents += 'new Vue(App)\n';
	return contents;
}

var fileType = '';

function walk(dir) {
	dir = dir || '.';
	const directory = pathTo.join(__dirname, 'src', dir);
	fs.readdirSync(directory)
		.forEach((file) => {
			const fullpath = pathTo.join(directory, file);
			const stat = fs.statSync(fullpath);
			const extname = pathTo.extname(fullpath);
			if(stat.isFile() && extname === '.vue' || extname === '.we') {
				if(!fileType) {
					fileType = extname;
				}
				if(fileType && extname !== fileType) {
					console.log('Error: This is not a good practice when you use ".we" and ".vue" togither!');
				}
				const name = pathTo.join(dir, pathTo.basename(file, extname));
				if(extname === '.vue') {
					const entryFile = pathTo.join(vueWebTemp, dir, pathTo.basename(file, extname) + '.js');
					fs.outputFileSync(pathTo.join(entryFile), getEntryFileContent(entryFile, fullpath));

					entry[name] = pathTo.join(__dirname, entryFile) + '?entry=true';
				}
				weexEntry[name] = fullpath + '?entry=true';
			} else if(stat.isDirectory() && file !== 'build' && file !== 'include') {
				const subdir = pathTo.join(dir, file);
				walk(subdir);
			}
		});
}

walk();
const plugins = [
	// new webpack.optimize.UglifyJsPlugin({
	// 	// minimize: true,
	// 	compress: {
	// 		warnings: false
	// 	}
	// }),
	new webpack.BannerPlugin({
		banner: '// { "framework": ' + (fileType === '.vue' ? '"Vue"' : '"Weex"') + '} \n',
		raw: true,
		exclude: 'Vue'
	})
];


const weexConfig = {
	entry: weexEntry,
	output: {
		path: pathTo.join(__dirname, 'dist', 'native'),
		filename: '[name].js',
		publicPath: '/dist/assets/',
	},
	module: {
		rules: [{
				test: /\.js$/,
				use: [{
					loader: 'babel-loader',
					query: {
						presets: ["es2015"]
					}
				}],
				exclude: /node_modules/
			},
			{
				test: /\.vue(\?[^?]+)?$/,
				use: [{
					loader: 'weex-loader'
				}]
			},
			{
			    test: /\.(png|jpg|gif|svg)$/,
			    loader: 'file-loader',
			    options: {
			        name: '[name].[ext]?[hash]'
			    }
			},
			{
			    test: /\.(eot|svg|ttf|woff|woff2)(\?\S*)?$/,
			    loader: 'file-loader'
			},
			{
				test: /\.we(\?[^?]+)?$/,
				use: [{
					loader: 'weex-loader'
				}]
			}
		]
	},
	plugins: plugins,
};
module.exports = {
	weexConfig: weexConfig
}
