import {Controller} from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["replyForm"]

    toggleReply(event) {
        event.preventDefault()
        this.replyFormTarget.classList.toggle("hidden")
        event.target.classList.toggle("hidden")
    }

    cancelReply(event) {
        event.preventDefault()
        const wrapper = this.element.closest("[data-controller='comment']")
        const replyForm = wrapper.querySelector("[data-comment-target='replyForm']")
        const replyLink = wrapper.querySelector("[data-action='comment#toggleReply']")
        if (replyForm) replyForm.classList.add("hidden")
        if (replyLink) replyLink.classList.remove("hidden")
    }
}
