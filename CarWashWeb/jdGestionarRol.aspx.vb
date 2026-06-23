Imports System.Data
Imports capaNegocio

Public Class jdGestionarRol
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        If Not IsPostBack Then
            cargarListView()
            desactivarControles()
            btnGuardar.Text = "Guardar"
            ocultarMensaje()
        End If
    End Sub

    Private Sub desactivarControles()
        txtNombreRol.Enabled = False
        txtDescripcion.Enabled = False
        cboEstado.Enabled = False
        btnCancelar.Enabled = False
        btnGuardar.Enabled = False
    End Sub

    Private Sub activarControles()
        txtNombreRol.Enabled = True
        txtDescripcion.Enabled = True
        cboEstado.Enabled = True
        btnCancelar.Enabled = True
        btnGuardar.Enabled = True
    End Sub

    ' =============================================
    ' GENERAR ID DE PREVISUALIZACIÓN
    ' =============================================
    Private Sub cargarIdRol()
        Dim objRol As New clsRol()
        Try
            txtIdRol.Text = objRol.generarIdRol().ToString()
        Catch ex As Exception
            mostrarMensaje("Error al generar ID: " & ex.Message, "alert-danger")
        End Try
    End Sub

    ' =============================================
    ' LISTADO DE ROLES
    ' =============================================
    Private Sub cargarListView()
        Dim objRol As New clsRol()
        Try
            Dim dt As DataTable = objRol.listarRoles()
            gvRoles.DataSource = dt
            gvRoles.DataBind()
        Catch ex As Exception
            mostrarMensaje("Error al cargar roles: " & ex.Message, "alert-danger")
        End Try
    End Sub

    Protected Sub gvRoles_SelectedIndexChanged(sender As Object, e As EventArgs) Handles gvRoles.SelectedIndexChanged
        Dim row As GridViewRow = gvRoles.SelectedRow
        If row Is Nothing Then Exit Sub

        txtIdRol.Text = row.Cells(0).Text
        txtNombreRol.Text = row.Cells(1).Text
        txtDescripcion.Text = row.Cells(3).Text

        cboEstado.SelectedValue = If(row.Cells(2).Text = "True", "True", "False")

        activarControles()
        btnGuardar.Text = "Actualizar"
    End Sub

    ' =============================================
    ' NUEVO ROL
    ' =============================================
    Protected Sub btnNuevoRol_Click(sender As Object, e As EventArgs) Handles btnNuevoRol.Click
        limpiarCampos()
        cargarIdRol()
        activarControles()
        btnGuardar.Text = "Guardar"
        Page.SetFocus(txtNombreRol)
    End Sub

    ' =============================================
    ' GUARDAR / ACTUALIZAR
    ' =============================================
    Protected Sub btnGuardar_Click(sender As Object, e As EventArgs) Handles btnGuardar.Click

        If txtNombreRol.Text.Trim() = "" Then
            mostrarMensaje("Ingrese el nombre del rol.", "alert-warning")
            Exit Sub
        End If

        If cboEstado.SelectedValue = "" Then
            mostrarMensaje("Seleccione un estado.", "alert-warning")
            Exit Sub
        End If

        Dim objRol As New clsRol()
        Dim estado As Boolean = Convert.ToBoolean(cboEstado.SelectedValue)

        Try
            If btnGuardar.Text = "Actualizar" Then
                objRol.modificarRol(
                    CInt(txtIdRol.Text),
                    txtNombreRol.Text.Trim(),
                    txtDescripcion.Text.Trim(),
                    estado
                )
                mostrarMensaje("Rol actualizado correctamente.", "alert-success")

            ElseIf btnGuardar.Text = "Guardar" Then
                objRol.registrarRol(
                    CInt(txtIdRol.Text),
                    txtNombreRol.Text.Trim(),
                    estado,
                    txtDescripcion.Text.Trim()
                )
                mostrarMensaje("Rol guardado correctamente.", "alert-success")
            End If

            limpiarCampos()
            cargarListView()
            btnGuardar.Text = "Guardar"

        Catch ex As Exception
            mostrarMensaje("Error al guardar rol: " & ex.Message, "alert-danger")
        End Try
    End Sub

    ' =============================================
    ' CANCELAR
    ' =============================================
    Protected Sub btnCancelar_Click(sender As Object, e As EventArgs) Handles btnCancelar.Click
        limpiarCampos()
        desactivarControles()
        btnGuardar.Text = "Guardar"
        ocultarMensaje()
    End Sub

    Private Sub limpiarCampos()
        txtNombreRol.Text = ""
        txtIdRol.Text = ""
        txtDescripcion.Text = ""
        cboEstado.SelectedValue = ""
    End Sub

    ' =============================================
    ' MENSAJES DE ÉXITO / AVISO / ERROR
    ' =============================================
    Private Sub mostrarMensaje(texto As String, cssClass As String)
        lblMensaje.Text = texto
        lblMensaje.CssClass = "gr-alert " & cssClass
        lblMensaje.Visible = True
    End Sub

    Private Sub ocultarMensaje()
        lblMensaje.Text = ""
        lblMensaje.Visible = False
    End Sub

End Class