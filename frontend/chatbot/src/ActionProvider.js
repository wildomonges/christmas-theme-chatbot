import React, { useEffect, useState } from 'react';
import useWebSocket from 'react-use-websocket';

const ActionProvider = ({ createChatBotMessage, setState, children }) => {
  const socketUrl = process.env.REACT_APP_WEBSOCKET_ENDPOINT;
  const [tokens, setTokens] = useState('');

  const { sendJsonMessage } = useWebSocket(socketUrl, {
    onMessage: (event) => {
      setTokens((prevTokens) => [...prevTokens, event.data]);
    },
  });

  useEffect(() => {
    if (tokens.length > 2) {
      const message = tokens.join(' ');
      const chatBotMessage = createChatBotMessage(message);

      setTokens([]);

      setState((prev) => ({
        ...prev,
        messages: [...prev.messages, chatBotMessage],
      }));
    }
  }, [tokens, createChatBotMessage, setState]);

  const handleSendMessage = (message) => {
    // workaround to send the accessToken to the websocket api
    // because useWebSocket does not support Authorization header
    const data = {
      message: message,
      accessToken: process.env.REACT_APP_ACCESS_TOKEN,
    };
    sendJsonMessage({ action: 'sendMessage', data: JSON.stringify(data) });
  };

  return (
    <div>
      {React.Children.map(children, (child) => {
        return React.cloneElement(child, {
          actions: {
            handleSendMessage,
          },
        });
      })}
    </div>
  );
};

export default ActionProvider;
