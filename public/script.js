let currentChat = "Alice";

function openChat(name) {
  currentChat = name;
  document.getElementById("chatHeader").textContent = name;
  document.querySelectorAll(".contact").forEach(c => c.classList.remove("active"));
  event.target.classList.add("active");
  document.getElementById("chatMessages").innerHTML = "";
}

function sendMessage() {
  const input = document.getElementById('chatInput');
  const messageText = input.value.trim();
  if (messageText === '') return;

  // Add user message
  addMessage(messageText, 'user');
  input.value = '';

  // Simulated bot reply
  setTimeout(() => {
    addMessage(`Reply from ${currentChat}: ${messageText}`, 'bot');
  }, 600);
}

function addMessage(text, sender) {
  const chatMessages = document.getElementById('chatMessages');
  const message = document.createElement('div');
  message.classList.add('message', sender);
  message.textContent = text;
  chatMessages.appendChild(message);
  chatMessages.scrollTop = chatMessages.scrollHeight;
}
