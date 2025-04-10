function validarDatos2() {
    var vacio = false;
    var msj = 'El campo es requerido';
    $('#lbl_nombre').html('');
    $('#lbl_apellido').html('');
    $('#lbl_correo').html('');
    $('#lbl_ciudad').html('');
    $('#lbl_telefono').html('');
    $('#lbl_domicilio').html('');
    $('#lbl_fecha_nac').html('');

    if (!val_vacio($('#nombre').val())) {
        $('#lbl_nombre').html(msj);
        vacio = true;
    }

    if (!val_vacio($('#apellido').val())) {
        $('#lbl_apellido').html(msj);
        vacio = true;
    }

    if (!val_vacio($('#correo').val())) {
        $('#lbl_correo').html(msj);
        vacio = true;
    }

    if (!val_vacio($('#doc_oficial').val())) {
        $('#lbl_doc_oficial').html(msj);
        vacio = true;
    }

    if (!val_vacio($('#telefono').val())) {
        $('#lbl_telefono').html(msj);
        vacio = true;
    }

    if (!val_vacio($('#domicilio').val())) {
        $('#lbl_domicilio').html(msj);
        vacio = true;
    }

    if (!val_vacio($('#fecha_nac').val())) {
        $('#lbl_fecha_nac').html(msj);
        vacio = true;
    }

    if (!vacio) {
        $("#frm_pago").submit();
    }
}

// Example starter JavaScript for disabling form submissions if there are invalid fields
(function() {
    'use strict';
    window.addEventListener('load', function() {
        // Fetch all the forms we want to apply custom Bootstrap validation styles to
        var forms = document.getElementsByClassName('needs-validation');
        // Loop over them and prevent submission
        var validation = Array.prototype.filter.call(forms, function(form) {
            form.addEventListener('submit', function(event) {
                if (form.checkValidity() === false) {
                    event.preventDefault();
                    event.stopPropagation();
                }
                form.classList.add('was-validated');
            }, false);
        });
    }, false);
})();

var id_ciudad = $("#id_ciudad").val();
var id_estado = $("#id_estado").val();

cargarPagina2("paises.php", "#div_pais", id_ciudad, id_estado, 0);

function formaPago(c) {
    if (c == 6) {
        $('#cupon').css('display', 'block');
    } else {
        $('#cupon').css('display', 'none');
    }
}

$('#btn_cupon').keypress(function( e ) {
    if(e.which === 32) 
        return false;
});

$( "#btn_cupon" ).click(function() {
    $('#div_cupon').hide();
    vacio = false;
    $('#div_estatus_cupon').html('<div class="cargando"><img src="https://www.evangelizacion.org.mx/imagenes/loading.gif" border="0" align="left" /> Cargando...</div>');

    if (!val_vacio($('#cupon').val())) {
        $('#div_cupon').show();
        $('#div_cupon').addClass('alert alert-warning');
        $('#div_cupon').html('Debes escribir el cupon');
        vacio = true;
    }

    if(!vacio){
        //se manda la forma para validar el cupon y el id_materia
        referencia = $('#referencia').val();
        cupon = $('#cupon').val();
        id_materia = $('#id_materia').val();

        $.ajax({
            url: '../widget/valida_cupon.php',
            data: 'param=' + id_materia + '&param2=' + cupon + "&param3=" + referencia,
            type: "POST",
            success: function(response) {
                //console.log(response[0]);
                         
                var respuesta_cupon = JSON.parse(response);
                //console.log(respuesta_cupon.valido+'  '+ respuesta_cupon.nuevo_monto);    
                cupon_valido = respuesta_cupon.valido;
                nuevo_monto = respuesta_cupon.nuevo_monto;
                tipo_cupon = respuesta_cupon.tipo_cupon;
                mensaje = respuesta_cupon.mensaje;
                var texto_mensaje = '';
                if(cupon_valido == 1){
                    $('#span_monto').html(nuevo_monto);
                    $('#span_monto_encabezado').html(nuevo_monto);

                    //if (tipo_cupon == 'dudc') {
                        if(mensaje == 'aplica_cupon_exitoso' || mensaje =='descuento_aplicado_exitoso') {
                            texto_mensaje = 'El cup&oacute;n ya fue aplicado exitosamente!.';

                            $('#div_cupon').show();
                            $('#div_cupon').addClass('alert alert-success');
                            $('#div_cupon').html(texto_mensaje);
                        }

                    //}
                } else {
                    if (mensaje == 'existe_susc_usuario') {
                        texto_mensaje = 'El cup&oacute;n ya fue aplicado a esta suscripci&oacute;n.';
                    } else if(mensaje == 'existe_cupon_suscrip') {
                        texto_mensaje = 'El cup&oacute;n ya fue aplicado a otra suscripci&oacute;n (otro usuario).';
                    }
                    if (texto_mensaje != '') {
                        $('#div_cupon').show();
                        $('#div_cupon').addClass('alert alert-warning');
                        $('#div_cupon').html(texto_mensaje);
                    }
                }

            }
        });
        $('#div_estatus_cupon').html('');
        //respuesta[] = cargarPagina2('../widget/valida_cupon.php', '#div_cupon', id_materia, cupon, referencia);
        
        //console.log(respuesta.valido);

        
    }else{
        console.log('en el falso...');
    }
    
  });
