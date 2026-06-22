Imports capaNegocio

Partial Class jdRecuperarContrasena
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            lblMensaje.Text = ""
            GenerarNuevoCaptcha()
        End If
    End Sub

    Private Sub GenerarNuevoCaptcha()
        Dim caracteres As String = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789"
        Dim rnd As New Random()
        Dim codigo As String = ""

        For i As Integer = 1 To 6
            codigo &= caracteres(rnd.Next(caracteres.Length))
        Next

        lblCaptcha.Text = codigo
        Session("CaptchaRecuperar") = codigo
    End Sub

    Protected Sub btnRefrescarCaptcha_Click(ByVal sender As Object, ByVal e As EventArgs)
        GenerarNuevoCaptcha()
        txtCaptchaIngresado.Text = ""
    End Sub

    Protected Sub btnBuscarPregunta_Click(ByVal sender As Object, ByVal e As EventArgs)

        lblMensaje.Text = ""
        Dim usuario As String = txtUsuario.Text.Trim()

        If usuario = "" Then
            MostrarError("Por favor, ingresa tu usuario.")
            Exit Sub
        End If

        Try
            Dim objTrabajador As New clsTrabajador()
            Dim pregunta As String = objTrabajador.PreguntaRecuperarContra(usuario)

            If pregunta = "" Then
                MostrarError("No se encontró una pregunta de seguridad para ese usuario.")
                lblPregunta.Text = "—"
                txtRespuesta.Enabled = False
                txtCaptchaIngresado.Enabled = False
                btnConfirmar.Enabled = False
                Exit Sub
            End If

            lblPregunta.Text = pregunta
            Session("UsuarioRecuperar") = usuario

            txtRespuesta.Enabled = True
            txtCaptchaIngresado.Enabled = True
            btnConfirmar.Enabled = True

            GenerarNuevoCaptcha()
            txtCaptchaIngresado.Text = ""

        Catch ex As Exception
            MostrarError("Error al buscar la pregunta: " & ex.Message)
        End Try

    End Sub

    Protected Sub btnConfirmar_Click(ByVal sender As Object, ByVal e As EventArgs)

        lblMensaje.Text = ""

        Dim usuario As String = Convert.ToString(Session("UsuarioRecuperar"))

        If usuario = "" Then
            MostrarError("Primero busca tu usuario y pregunta de seguridad.")
            Exit Sub
        End If

        Dim captchaGenerado As String = Convert.ToString(Session("CaptchaRecuperar"))
        If txtCaptchaIngresado.Text.Trim().ToUpper() <> captchaGenerado.ToUpper() Then
            MostrarError("El código captcha ingresado no es correcto.")
            GenerarNuevoCaptcha()
            txtCaptchaIngresado.Text = ""
            Exit Sub
        End If

        Try
            Dim objTrabajador As New clsTrabajador()
            Dim respuestaCorrecta As String = objTrabajador.RespuestaRecuperarContra(usuario)

            If txtRespuesta.Text.Trim().ToUpper() <> respuestaCorrecta.Trim().ToUpper() Then
                MostrarError("La respuesta ingresada es incorrecta.")
                GenerarNuevoCaptcha()
                txtCaptchaIngresado.Text = ""
                Exit Sub
            End If

            MostrarExito("Verificación correcta. Ahora puedes establecer tu nueva contraseña.")
            txtNuevaContrasena.Enabled = True
            txtConfirmarContrasena.Enabled = True
            btnGuardar.Enabled = True

            txtRespuesta.Enabled = False
            txtCaptchaIngresado.Enabled = False
            btnConfirmar.Enabled = False

            Session("VerificacionRecuperarOK") = True

        Catch ex As Exception
            MostrarError("Error al validar la respuesta: " & ex.Message)
        End Try

    End Sub

    Protected Sub btnGuardar_Click(ByVal sender As Object, ByVal e As EventArgs)

        lblMensaje.Text = ""

        Dim usuario As String = Convert.ToString(Session("UsuarioRecuperar"))

        If usuario = "" Or Not Convert.ToBoolean(Session("VerificacionRecuperarOK")) Then
            MostrarError("Debes completar la verificación de seguridad antes de cambiar la contraseña.")
            Exit Sub
        End If

        Dim nuevaPass As String = txtNuevaContrasena.Text.Trim()
        Dim confirmarPass As String = txtConfirmarContrasena.Text.Trim()

        If nuevaPass = "" Or confirmarPass = "" Then
            MostrarError("Por favor, completa ambos campos de contraseña.")
            Exit Sub
        End If

        If nuevaPass <> confirmarPass Then
            MostrarError("Las contraseñas no coinciden.")
            Exit Sub
        End If

        If nuevaPass.Length < 6 Then
            MostrarError("La contraseña debe tener al menos 6 caracteres.")
            Exit Sub
        End If

        If nuevaPass.Length > 15 Then
            MostrarError("La contraseña no puede tener más de 15 caracteres.")
            Exit Sub
        End If

        Try
            Dim objTrabajador As New clsTrabajador()
            objTrabajador.NuevaContrasena(nuevaPass, usuario)

            MostrarExito("Tu contraseña se actualizó correctamente. Ya puedes iniciar sesión.")

            Session("UsuarioRecuperar") = Nothing
            Session("VerificacionRecuperarOK") = Nothing

            txtNuevaContrasena.Enabled = False
            txtConfirmarContrasena.Enabled = False
            btnGuardar.Enabled = False

        Catch ex As Exception
            MostrarError("Error al guardar la nueva contraseña: " & ex.Message)
        End Try

    End Sub

    Private Sub MostrarError(ByVal mensaje As String)
        lblMensaje.CssClass = "mensaje-error"
        lblMensaje.Text = mensaje
    End Sub

    Private Sub MostrarExito(ByVal mensaje As String)
        lblMensaje.CssClass = "mensaje-exito"
        lblMensaje.Text = mensaje
    End Sub

End Class