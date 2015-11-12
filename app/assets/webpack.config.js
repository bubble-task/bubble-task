module.exports = {
  context: __dirname + '/javascripts',
  entry: './webpack_application.js',
  output: {
    filename: 'webpack.bundle.js',
    path: __dirname + '/javascripts',
  },
  module: {
    loaders: [
      { test: /\.jsx?$/, exclude: /node_modules/, loader: 'babel-loader' }
    ]
  },
  resolve: {
    extensions: ['', '.js', '.jsx'],
    modulesDirectories: ['node_modules', 'javascripts']
  },
};
