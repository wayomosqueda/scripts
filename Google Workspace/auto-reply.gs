/*
Purpose of the Script:
Autoreply to the 'reply-to' field when a user request access to a private Shared Drive
Workspace Admins: https://workspaceadmins.org
*/

function addtoGroup() 
{
  try 
  {
    // ... tu código original ...
    var interval = 2;    //  if the script runs every 2 minutes; change otherwise
    var timeFrom = Math.floor(Date.now()/1000) - 60 * interval;
    var threads = GmailApp.search('label: "Access Request" after:' + timeFrom);
    for (var i = 0; i < threads.length; i++) 
    {
      var messages = threads[i].getMessages();
      if (messages.length > 0) 
      {      // Hay al menos un mensaje, procede a procesarlo
        var ReplyToEmail = messages[0].getReplyTo().match(/([^<]+@[^>]+)/)[1];
        messages[0].reply("Este es un correo automatizado. \n\nSi usted solicitó acceso a una unidad compartida, le solicitamos ponerse en contacto con un miembro del grupo al cual desea acceder para que le autorice el acceso.\n\nEn caso de requerir asistencia específica para algún caso, puede escribir a: ayuda@schoenstatt.mx y nos pondremos en contacto lo antes posible.\n\nGracias.",
        {
          cc:"mexico@schoenstatt.mx"
        });
      }  else {Logger.log("No hay mensajes en este thread.");}
    }
    // Marcar como leído y mover a una carpeta
    messages[0].markRead();
    messages[0].moveToTrash(); // O a una carpeta específica

  } catch (error) 
  {
    Logger.log('Error al procesar el email: ' + error);
    // Enviar una notificación por email o a una plataforma de mensajería
  }
}
