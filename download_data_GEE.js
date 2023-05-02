function runTaskList()
{
var taskList = document.querySelector("#task-pane").shadowRoot.querySelector("div.client-task-pane > div ");
var taskLength = taskList.children.length;
for(var i=0;i<taskLength ;i++){
      taskList.children[i].children[1].click()
}
}
runTaskList();


function confirm()
{
var ee_dialog = document.querySelectorAll('body > ee-image-config-dialog')
//如果是image则为var ee_dialog = document.querySelectorAll('body > ee-image-config-dialog')
for(var i=0;i<ee_dialog.length;i++)
ee_dialog[i].shadowRoot.querySelector("ee-dialog").shadowRoot.querySelector("paper-dialog > div.buttons > ee-button.ok-button").click();

}
confirm();
