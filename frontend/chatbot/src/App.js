import Chatbot from 'react-chatbot-kit';
import 'react-chatbot-kit/build/main.css';

import config from './config.js';
import MessageParser from './MessageParser';
import ActionProvider from './ActionProvider.js';

function App() {
  return (
    <Chatbot
      config={config}
      messageParser={MessageParser}
      actionProvider={ActionProvider}
    />
  );
}

export default App;
