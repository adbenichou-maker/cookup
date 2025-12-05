import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["messages"]

  connect() {
    this.typingIndicator = document.getElementById("typing-indicator")
  }

  showTyping() {
    this.typingIndicator.classList.remove("hidden")

    // Smooth scroll to bottom
    this.messagesTarget.scrollTo({
      top: this.messagesTarget.scrollHeight,
      behavior: "smooth"
    })
  }

  hideTyping() {
    this.typingIndicator.classList.add("hidden")
  }
}
