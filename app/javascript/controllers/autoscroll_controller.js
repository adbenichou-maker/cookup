import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["messages"]

  connect() {
    // Small delay to ensure DOM is fully rendered
    setTimeout(() => this.scrollToLatestMessage(), 50)
  }

  messagesTargetChanged() {
    this.scrollToLatestMessage()
  }

  scrollToLatestMessage() {
    const container = this.messagesTarget
    const messageRows = container.querySelectorAll(".message-row")

    if (messageRows.length === 0) return

    // Find the last assistant message
    let lastAssistantMessage = null
    for (let i = messageRows.length - 1; i >= 0; i--) {
      if (messageRows[i].querySelector(".chat-assistant")) {
        lastAssistantMessage = messageRows[i]
        break
      }
    }

    // Scroll to the top of the last assistant message, or last message if no assistant
    const targetMessage = lastAssistantMessage || messageRows[messageRows.length - 1]

    // Use scrollIntoView to position message at the top of visible area
    targetMessage.scrollIntoView({ behavior: "auto", block: "start" })
  }
}
