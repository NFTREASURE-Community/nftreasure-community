// Chatbot Toggle Button
document.getElementById('chatbot-toggle').addEventListener('click', function() {

	var chatContainer = document.getElementById('chatbot-container');
  var chatToggle = document.getElementById('chatbot-toggle');

  chatContainer.style.display = "flex";
  chatToggle.style.display = "none";

});


// Close Chatbot on Outside Click
document.addEventListener('click', function(e) {

	var chatContainer = document.getElementById('chatbot-container');
  var chatToggle = document.getElementById('chatbot-toggle');
  var clickedInsideChat = chatContainer.contains(e.target) || chatToggle.contains(e.target);

  if (!clickedInsideChat && chatContainer.style.display === "flex") {
    chatContainer.style.display = "none";
    chatToggle.style.display = "block";
  }

}, true);

// Chatbot Input
document.getElementById('chatbot-input').addEventListener('keypress', function(e) {

	if (e.key === 'Enter' && !e.shiftKey) {

		e.preventDefault(); // Prevent the default action to stop from submitting form
    document.getElementById('chatbot-send-btn').click(); // Trigger click on send button

	}

});

// Chatbot Send Button
document.getElementById('chatbot-send-btn').addEventListener('click', async function() {

    // Disable the button to prevent multiple clicks.
    this.disabled = true;

    const inputElement = document.getElementById('chatbot-input');
    const message = inputElement.value.trim();
    const sender = 'user';

    if (message) {
        addMessageToChat(sender, message);
        await sendMessageToServer(message);
        inputElement.value = '';
    }

    this.disabled = false;

});

// Chatbot Message adding function
function addMessageToChat(sender, message) {

  const chatMessages = document.getElementById('chatbot-messages');

  // Create the container for the whole message, including avatar and text
  const messageContainer = document.createElement('div');
  messageContainer.classList.add('chat-message');

  // Create the avatar image element
  const avatarImg = document.createElement('img');
  avatarImg.classList.add('avatar');

  if (sender === 'user') {

    avatarImg.src = '/img/avatars/user.png';
    messageContainer.classList.add('user');

  } else {

    avatarImg.src = '/img/avatars/support.png';
    messageContainer.classList.add('bot');

  }

  // Create the text container for the message
  const messageText = document.createElement('div');
  messageText.innerHTML = message.replace(/\n/g, '<br/>');

  if (sender === 'user') {

    // For the user, the avatar should be on the left
    messageContainer.appendChild(avatarImg);
    messageContainer.appendChild(messageText);

  } else {

    // For the bot, the avatar should be on the right
    messageContainer.appendChild(messageText);
    messageContainer.appendChild(avatarImg);

  }

  // Append the message container to the chat messages container
  chatMessages.appendChild(messageContainer);

  // Auto-scroll to the latest message
  requestAnimationFrame(() => {
    requestAnimationFrame(() => {
      chatMessages.scrollTop = chatMessages.scrollHeight;
    });
  });

}

// Chatbot Server Message
async function sendMessageToServer(message) {

  // Chatbot URL
  const chatbotUrl = document.getElementById('chatbotConfig').getAttribute('data-chatbot-url');
  const sender = 'bot';
  const friendlyMessage = "Sorry degen but it looks like Ron Jay has rugged. Here is some nerd stuff to paste into the Discord.";

  console.info(`Sending message to ${sender}: ${message}`);

  // Timeout
  const timeoutPromise = new Promise((resolve, reject) => {
    setTimeout(() => {
      reject(`${sender} took too long to respond. Please try again later.`);
    }, 5000); // 5 seconds
  });

  try {
    const response = await Promise.race([
      fetch(chatbotUrl, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ message: message }),
      }),
      timeoutPromise
    ]);

    if (response.ok) {
      const data = await response.json();
      console.info(`${sender} has responded with:`, data);

      console.info('Question:', data.message || "No question was provided.");
      console.info('Response:', data.reply || "No response was given.");
      console.info('Error:', data.error || "No error.");

      if (data.error) {
        addMessageToChat(sender, `${data.error}\n\n${friendlyMessage}`);
      } else {
        addMessageToChat(sender, data.reply);
      }
    } else {
      console.error(`ERROR: ${response.statusText}`);
      addMessageToChat(sender, `${friendlyMessage}\n\n${response.statusText}`);
    }
  } catch (error) {
    console.error(`ERROR: ${error}`);
    addMessageToChat(sender, `${friendlyMessage}\n\n${error}`);
  }
}
