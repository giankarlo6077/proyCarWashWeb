Imports System.Data
Imports com.somee.wspruebacarwash2

Partial Class jdGestionarUsuario
    Inherits System.Web.UI.Page

    Dim objTrabajador As New WSv1

    '================================================================
    ' AL CARGAR EL FORMULARIO
    '================================================================
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load

        If Session("Usuario") Is Nothing Then
            Response.Redirect("jdInicioSesion.aspx")
            Exit Sub
        End If
        Seguridad.ExigirAdministrador(Me)

        If Not Page.IsPostBack Then
            Try
                CargarTablaUsuarios()
                LimpiarFormulario()
            Catch ex As Exception
                MostrarError("Error al cargar el formulario: " & ex.Message)
            End Try
        End If

    End Sub

    '================================================================
    ' MÉTODOS DE APOYO
    '================================================================
    Private Sub CargarTablaUsuarios(Optional ByVal filtro As String = "")
        dgvUsuarios.DataSource = If(filtro = "", objTrabajador.ListarUsuariosGrid(), objTrabajador.BuscarUsuariosGrid(filtro))
        dgvUsuarios.DataBind()
    End Sub

    Private Sub LimpiarFormulario()
        hdnIdTrabajador.Value = "0"
        txtTrabajador.Text = ""
        txtUsuario.Text = ""
        txtContrasena.Text = ""
        txtConfirmarContrasena.Text = ""
        ddlPregunta.SelectedIndex = 0
        txtRespuesta.Text = ""
        chkActivo.Checked = True
    End Sub

    '================================================================
    ' BOTONERA DE ACCIONES
    '================================================================
    Protected Sub btnNuevo_Click(ByVal sender As Object, ByVal e As EventArgs)
        LimpiarFormulario()
        MostrarExito("Seleccione un trabajador de la tabla haciendo clic en ""Seleccionar"" para asignarle un usuario.")
    End Sub

    Protected Sub btnCancelar_Click(ByVal sender As Object, ByVal e As EventArgs)
        LimpiarFormulario()
        lblMensaje.Text = ""
    End Sub

    Protected Sub btnGuardar_Click(ByVal sender As Object, ByVal e As EventArgs)

        lblMensaje.Text = ""
        Dim idTrabajadorSeleccionado As Integer = Convert.ToInt32(hdnIdTrabajador.Value)

        If idTrabajadorSeleccionado = 0 Then
            MostrarError("Debe seleccionar un trabajador de la tabla haciendo clic en ""Seleccionar"".")
            Exit Sub
        End If

        If txtUsuario.Text.Trim() = "" Or txtContrasena.Text.Trim() = "" Or txtRespuesta.Text.Trim() = "" Then
            MostrarError("Por favor complete todos los campos.")
            Exit Sub
        End If

        If ddlPregunta.SelectedValue = "" Then
            MostrarError("Debe seleccionar una pregunta de seguridad.")
            Exit Sub
        End If

        If txtContrasena.Text <> txtConfirmarContrasena.Text Then
            MostrarError("Las contraseñas no coinciden.")
            Exit Sub
        End If

        If txtContrasena.Text.Length > 15 Then
            MostrarError("La contraseña no puede tener más de 15 caracteres.")
            Exit Sub
        End If

        Try
            Dim preguntaStr As String = ddlPregunta.SelectedValue

            objTrabajador.GuardarCredenciales(idTrabajadorSeleccionado, txtUsuario.Text.Trim(), txtContrasena.Text, preguntaStr, txtRespuesta.Text.Trim(), chkActivo.Checked)

            MostrarExito("Credenciales guardadas correctamente.")
            LimpiarFormulario()
            CargarTablaUsuarios()

        Catch ex As Exception
            MostrarError("Error al guardar: " & ex.Message)
        End Try

    End Sub

    '================================================================
    ' BUSCADOR
    '================================================================
    Protected Sub btnBuscar_Click(ByVal sender As Object, ByVal e As EventArgs)
        CargarTablaUsuarios(txtBuscar.Text.Trim())
    End Sub

    Protected Sub txtBuscar_TextChanged(ByVal sender As Object, ByVal e As EventArgs)
        CargarTablaUsuarios(txtBuscar.Text.Trim())
    End Sub

    '================================================================
    ' SELECCIONAR FILA DEL GRID
    '================================================================
    Protected Sub dgvUsuarios_RowCommand(ByVal sender As Object, ByVal e As GridViewCommandEventArgs)

        If e.CommandName = "Seleccionar" Then

            Dim idTrabajador As Integer = Convert.ToInt32(e.CommandArgument)

            Dim filaSeleccionada As GridViewRow = Nothing
            For Each fila As GridViewRow In dgvUsuarios.Rows
                If Convert.ToInt32(dgvUsuarios.DataKeys(fila.RowIndex).Value) = idTrabajador Then
                    filaSeleccionada = fila
                    Exit For
                End If
            Next

            If filaSeleccionada IsNot Nothing Then
                hdnIdTrabajador.Value = idTrabajador.ToString()
                txtTrabajador.Text = Server.HtmlDecode(filaSeleccionada.Cells(1).Text)
                txtUsuario.Text = Server.HtmlDecode(filaSeleccionada.Cells(2).Text)

                Dim activoTexto As String = filaSeleccionada.Cells(3).Text
                chkActivo.Checked = (activoTexto = "Sí")

                ' Limpiamos contraseñas y respuesta por seguridad
                txtContrasena.Text = ""
                txtConfirmarContrasena.Text = ""
                txtRespuesta.Text = ""

                ' La pregunta actual se preselecciona en el combo, consultándola directo de la BD
                Try
                    Dim preguntaActual As String = objTrabajador.PreguntaRecuperarContra(txtUsuario.Text.Trim())
                    Dim item As ListItem = ddlPregunta.Items.FindByValue(preguntaActual)
                    ddlPregunta.SelectedIndex = If(item IsNot Nothing, ddlPregunta.Items.IndexOf(item), 0)

                Catch ex As Exception
                    ddlPregunta.SelectedIndex = 0
                End Try

                lblMensaje.Text = ""
            End If

        End If

    End Sub

    '================================================================
    ' HELPERS DE MENSAJES
    '================================================================
    Private Sub MostrarError(ByVal mensaje As String)
        lblMensaje.CssClass = "mensaje-error"
        lblMensaje.Text = mensaje
    End Sub

    Private Sub MostrarExito(ByVal mensaje As String)
        lblMensaje.CssClass = "mensaje-exito"
        lblMensaje.Text = mensaje
    End Sub



End Class