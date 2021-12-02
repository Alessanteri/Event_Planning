import $ from "jquery"
import { Socket } from "phoenix"

let socket = new Socket("/socket", { params: { token: window.userToken } })

socket.connect()

let channel = socket.channel("update_data:lobby", {})

channel.join()
    .receive("ok", resp => {
        console.log("Joined successfully", resp)


    })
    .receive("error", resp => {
        console.log("Unable to join", resp)
    })

let submitButton = $("#add")

let updateButton = $("#update")

let deleteButton = $("#delete")

submitButton.click(() => {
    let { value: repetition } = document.querySelector('#repetition')
    let { value: date_year } = document.querySelector('#start_date_year')
    let { value: date_month } = document.querySelector('#start_date_month')
    let { value: date_day } = document.querySelector('#start_date_day')
    let { value: date_hour } = document.querySelector('#start_date_hour')
    let { value: date_minute } = document.querySelector('#start_date_minute')
    let { value: enabled } = document.querySelector('#enabled')
    let { value: name } = document.querySelector('#name_event')
    let id_user = document.getElementById('id_user').textContent
    channel.push('new_event', { message: { repetition, date_year, date_month, date_day, date_hour, date_minute, enabled, name, id_user } })
})

updateButton.click(() => {
    let { value: id } = document.querySelector('#event-from_id')
    let { value: repetition } = document.querySelector('#repetition')
    let { value: date_year } = document.querySelector('#start_date_year')
    let { value: date_month } = document.querySelector('#start_date_month')
    let { value: date_day } = document.querySelector('#start_date_day')
    let { value: date_hour } = document.querySelector('#start_date_hour')
    let { value: date_minute } = document.querySelector('#start_date_minute')
    let { value: enabled } = document.querySelector('#enabled')
    let { value: name } = document.querySelector('#name_event')
    channel.push('update_event', { message: { repetition, date_year, date_month, date_day, date_hour, date_minute, enabled, id, name } })
})

deleteButton.click(() => {
    let id = document.getElementById('id_event').textContent
    channel.push('delete_event', { message: id })
})


channel.on("new_event", (payload) => {
    renderHTML(payload)
})

channel.on("update_event", (payload) => {
    $("#" + payload.id).hide()
    renderHTML(payload)
})

channel.on("delete_event", (payload) => {
    $("#" + payload.id).hide()
})


const renderHTML = function (message) {
    document.querySelector("#event").innerHTML += message.html_template

}


export default socket