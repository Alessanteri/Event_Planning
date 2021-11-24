import $ from "jquery"
import { Socket } from "phoenix"

let socket = new Socket("/socket", { params: { token: window.userToken } })

socket.connect()

// Now that you are connected, you can join channels with a topic:
let channel = socket.channel("update_data:lobby", {})

channel.join()
    .receive("ok", resp => {
        console.log("Joined successfully", resp)

    })
    .receive("error", resp => {
        console.log("Unable to join", resp)
    })

let submitButton = $("#submit")

submitButton.click(() => {
    let { value: repetition } = document.querySelector('#repetition')
    let { value: date_year } = document.querySelector('#start_date_year')
    let { value: date_month } = document.querySelector('#start_date_month')
    let { value: date_day } = document.querySelector('#start_date_day')
    let { value: date_hour } = document.querySelector('#start_date_hour')
    let { value: date_minute } = document.querySelector('#start_date_minute')
    let { value: enabled } = document.querySelector('#enabled')
    channel.push('adding_new_event', { message: { repetition, date_year, date_month, date_day, date_hour, date_minute, enabled } })
    location.reload()
})


channel.on("adding_new_event", (payload) => {
    location.reload()
})


export default socket