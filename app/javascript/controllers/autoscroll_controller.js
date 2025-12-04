import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["messages"]

  connect() {
    this.scrollToLatest()
  }

  messagesTargetChanged() {
    this.scrollToLatest()
  }

  scrollToLatest() {
    const container = this.messagesTarget
    const messages = container.children

    if (messages.length === 0) return

    const lastMessage = messages[messages.length - 1]

    // Scroll so that the last message appears at the TOP of the container
    container.scrollTop = lastMessage.offsetTop
  }
}
