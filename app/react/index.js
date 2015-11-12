import React from 'react';
import ReactDOM from 'react-dom';
window.React = React;
window.ReactDOM = ReactDOM;

import Greeting from './components/greeting';
registerComponent('Greeting', Greeting);
