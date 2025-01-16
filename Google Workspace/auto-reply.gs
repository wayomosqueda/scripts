/*
Purpose of the Script:
Autoreply to the 'reply-to' field when a user request access to a private Shared Drive
*/

function addtoGroup() {
  try {
    var interval = 2;    // if the script runs every 2 minutes; change otherwise
    var timeFrom = Math.floor(Date.now()/1000) - 60 * interval;
    var threads = GmailApp.search('label: "Access Request" after:' + timeFrom);
    for (var i = 0; i < threads.length; i++) {
      var messages = threads[i].getMessages();
      if (messages.length > 0) {  // There is at least one message, proceed to process it
        var ReplyToEmail = messages[0].getReplyTo().match(/([^<]+@[^>]+)/)[1];
        GmailApp.sendEmail(ReplyToEmail, "Acceso a Unidad Compartida", 
          "Este es un correo automatizado.\n\nSi usted solicitó acceso a una unidad compartida o a una carpeta, le solicitamos ponerse en contacto con un miembro del grupo al cual desea acceder para para que le autorice el acceso.\n\nEn caso de requerir asistencia específica para algún caso, puede escribir a: ayuda@schoenstatt.mx y nos pondremos en contacto lo antes posible.\n\nGracias.", 
          {
            name: "Schoenstatt México",
            cc: ""
          }
        );
        
        // Mark as read and move to trash
        messages[0].markRead();
        messages[0].moveToTrash(); // Or to a specific folder
      } else {
        Logger.log("No hay mensajes en este thread.");
      }
    }
  } catch (error) {
    Logger.log('Error al procesar el email: ' + error);
    // Send a notification via email or to a messaging platform
  }
}
