import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.typingIndicator = document.getElementById("typing-indicator")
    this.messagesContainer = document.getElementById("messages")
  }

  showTyping() {
    this.typingIndicator.classList.remove("hidden")
    // Don't scroll - just show the indicator where it is
    // The page will scroll to the new message when it loads
  }

  hideTyping() {
    this.typingIndicator.classList.add("hidden")
  }
}
