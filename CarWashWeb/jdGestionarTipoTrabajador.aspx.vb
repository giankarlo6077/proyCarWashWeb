Imports System.Data
Imports capaNegocio

Partial Class jdGestionarTipoTrabajador
    Inherits System.Web.UI.Page

    Dim objTipoTrabajador As New clsTipoTrabajador()

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
        If Session("Usuario") Is Nothing Then
            Response.Redirect("jdInicioSesion.aspx")
            Exit Sub
        End If

        If Not Page.IsPostBack Then
            listar()
            btnRegistrar.Enabled = False
            btnModificar.Enabled = False
            ' Agregar confirmación en cliente al botón Eliminar
            btnEliminar.OnClientClick = "return confirmarEliminar();"
        End If
    End Sub

    '========================================
    ' LISTAR
    '========================================
    Sub listar()
        Try
            lblMensaje.Text = ""
            Dim dt As DataTable = objTipoTrabajador.listarTipoTrabajador()
            dgvTipoTrabajador.DataSource = dt
            dgvTipoTrabajador.DataBind()
        Catch ex As Exception
            MostrarError("Error al listar: " & ex.Message)
        End Try
    End Sub

    '========================================
    ' LIMPIAR
    '========================================
    Sub limpiar()
        txtTipoTrabajador.Text = ""
        hdnIdSeleccionado.Value = "0"
        btnRegistrar.Enabled = False
        btnModificar.Enabled = False
        lblMensaje.Text = ""
        txtTipoTrabajador.Focus()
    End Sub

    Protected Sub btnNuevo_Click(ByVal sender As Object, ByVal e As EventArgs)
        limpiar()
        btnRegistrar.Enabled = True
        btnModificar.Enabled = False
    End Sub

    '========================================
    ' REGISTRAR
    '========================================
    Protected Sub btnRegistrar_Click(ByVal sender As Object, ByVal e As EventArgs)
        If txtTipoTrabajador.Text.Trim() = "" Then
            MostrarError("Ingrese tipo de trabajador")
            txtTipoTrabajador.Focus()
            Exit Sub
        End If

        Try
            objTipoTrabajador.registrarTipoTrabajador(txtTipoTrabajador.Text.Trim())
            MostrarExito("Registro exitoso")
            listar()
            limpiar()
        Catch ex As Exception
            MostrarError(ex.Message)
        End Try
    End Sub

    '========================================
    ' MODIFICAR
    '========================================
    Protected Sub btnModificar_Click(ByVal sender As Object, ByVal e As EventArgs)
        Dim idSeleccionado As Integer = Convert.ToInt32(hdnIdSeleccionado.Value)

        If idSeleccionado = 0 Then
            MostrarError("Seleccione un registro")
            Exit Sub
        End If

        If txtTipoTrabajador.Text.Trim() = "" Then
            MostrarError("Ingrese tipo de trabajador")
            txtTipoTrabajador.Focus()
            Exit Sub
        End If

        Try
            objTipoTrabajador.modificarTipoTrabajador(idSeleccionado, txtTipoTrabajador.Text.Trim())
            MostrarExito("Modificado correctamente")
            listar()
            limpiar()
        Catch ex As Exception
            MostrarError(ex.Message)
        End Try
    End Sub

    '========================================
    ' ELIMINAR
    '========================================
    Protected Sub btnEliminar_Click(ByVal sender As Object, ByVal e As EventArgs)
        Dim idSeleccionado As Integer = Convert.ToInt32(hdnIdSeleccionado.Value)

        If idSeleccionado = 0 Then
            MostrarError("Seleccione un registro")
            Exit Sub
        End If

        Try
            objTipoTrabajador.eliminarTipoTrabajador(idSeleccionado)
            MostrarExito("Eliminado correctamente")
            listar()
            limpiar()
        Catch ex As Exception
            MostrarError(ex.Message)
        End Try
    End Sub

    Protected Sub btnLimpiar_Click(ByVal sender As Object, ByVal e As EventArgs)
        limpiar()
    End Sub

    Protected Sub btnSalir_Click(ByVal sender As Object, ByVal e As EventArgs)
        ' Al ser un formulario invocado desde la gestión, regresamos a la pantalla anterior
        Response.Redirect("jdGestionarTrabajador.aspx")
    End Sub

    '========================================
    ' EVENTOS DEL GRIDVIEW (SELECCIONAR FILA)
    '========================================
    Protected Sub dgvTipoTrabajador_RowCommand(ByVal sender As Object, ByVal e As GridViewCommandEventArgs)
        If e.CommandName = "SelectRow" Then
            ' Descomponer los argumentos pasados (ID y Nombre)
            Dim argumentos As String() = e.CommandArgument.ToString().Split("|"c)
            Dim idSelected As String = argumentos(0)
            Dim nombreSelected As String = argumentos(1)

            hdnIdSeleccionado.Value = idSelected
            txtTipoTrabajador.Text = nombreSelected

            ' Configuración de control de botones
            btnRegistrar.Enabled = False
            btnModificar.Enabled = True

            listar()
        End If
    End Sub

    Protected Sub dgvTipoTrabajador_RowDataBound(ByVal sender As Object, ByVal e As GridViewRowEventArgs)
        If e.Row.RowType = DataControlRowType.DataRow Then
            Dim idSelected As Integer = Convert.ToInt32(hdnIdSeleccionado.Value)
            Dim rowId As Integer = Convert.ToInt32(dgvTipoTrabajador.DataKeys(e.Row.RowIndex).Value)

            If rowId = idSelected Then
                e.Row.CssClass = "fila-seleccionada"
            End If
        End If
    End Sub

    '========================================
    ' HELPERS MENSAJES
    '========================================
    Private Sub MostrarError(ByVal mensaje As String)
        lblMensaje.CssClass = "mensaje-error"
        lblMensaje.Text = mensaje
    End Sub

    Private Sub MostrarExito(ByVal mensaje As String)
        lblMensaje.CssClass = "mensaje-exito"
        lblMensaje.Text = mensaje
    End Sub
End Class