import { createChatBotMessage } from 'react-chatbot-kit';

const config = {
  initialMessages: [
    createChatBotMessage(
      `Ho ho ho! This is Santa Clous! Happy to talk to you!`
    ),
  ],
  botName: 'Santa Clous',
  customStyles: {
    botMessageBox: { backgroundColor: '#34A65F' },
    chatButton: { backgroundColor: '#5ccc9d' },
  },
};

export default config;
