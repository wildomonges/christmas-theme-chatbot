import React, { useEffect, useState } from 'react';
import useWebSocket from 'react-use-websocket';

const ActionProvider = ({ createChatBotMessage, setState, children }) => {
  const socketUrl = 'wss://n6n7punoyj.execute-api.us-east-1.amazonaws.com/dev/';
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
    sendJsonMessage({ action: 'sendMessage', data: message });
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
