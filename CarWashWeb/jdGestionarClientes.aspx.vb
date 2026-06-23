Imports System.Data
Imports capaNegocio

Public Class jdGestionarClientes
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        If Not IsPostBack Then
            cargarTiposDocumento()
            ocultarMensaje()
        End If
    End Sub

    ' =============================================
    ' CARGA TIPO DE DOCUMENTO
    ' (En el escritorio se armaba una DataTable en memoria solo con "DNI")
    ' =============================================
    Private Sub cargarTiposDocumento()
        Try
            cboTipoDoc.Items.Clear()
            cboTipoDoc.Items.Add(New ListItem("DNI", "1"))
            cboTipoDoc.SelectedIndex = 0
        Catch ex As Exception
            mostrarMensaje("Error al cargar el tipo de documento: " & ex.Message, "alert-danger")
        End Try
    End Sub

    ' =============================================
    ' BUSCAR PERSONA POR N° DOCUMENTO
    ' =============================================
    Protected Sub btnBuscarPer_Click(sender As Object, e As EventArgs) Handles btnBuscarPer.Click
        If txtDoc.Text.Trim() = "" Then
            mostrarMensaje("Ingrese un número de documento.", "alert-warning")
            Exit Sub
        End If

        Dim objPersona As New clsPersona()
        Try
            Dim dt As DataTable = objPersona.buscarPersonaRapida(txtDoc.Text.Trim())

            If dt.Rows.Count > 0 Then
                txtNombreAp.Text = dt.Rows(0)("persona").ToString()
                txtCorreo.Text = dt.Rows(0)("correo").ToString()
                txtTelefono.Text = dt.Rows(0)("telefono").ToString()
                txtRazonSocial.Text = ""
                mostrarMensaje("Persona encontrada correctamente.", "alert-success")
            Else
                limpiarCamposPersona()
                mostrarMensaje("No se encontró ninguna persona con ese documento.", "alert-warning")
            End If

        Catch ex As Exception
            mostrarMensaje("Error al buscar persona: " & ex.Message, "alert-danger")
        End Try
    End Sub

    ' =============================================
    ' BUSCAR EMPRESA POR RUC
    ' =============================================
    Protected Sub btnBuscarEm_Click(sender As Object, e As EventArgs) Handles btnBuscarEm.Click
        If txtRUC.Text.Trim() = "" Then
            mostrarMensaje("Ingrese un RUC.", "alert-warning")
            Exit Sub
        End If

        Dim objEmpresa As New clsEmpresa()
        Try
            Dim dt As DataTable = objEmpresa.buscarEmpresaRUC(txtRUC.Text.Trim())

            If dt.Rows.Count > 0 Then
                txtRazonSocial.Text = dt.Rows(0)("razonSocial").ToString()
                mostrarMensaje("Empresa encontrada correctamente.", "alert-success")
            Else
                txtRazonSocial.Text = ""
                mostrarMensaje("No se encontró ninguna empresa con ese RUC.", "alert-warning")
            End If

        Catch ex As Exception
            mostrarMensaje("Error al buscar empresa: " & ex.Message, "alert-danger")
        End Try
    End Sub

    ' =============================================
    ' NAVEGACIÓN A OTROS FORMULARIOS
    ' (Equivalente web de los antiguos .ShowDialog())
    ' =============================================
    Protected Sub btnNuevaPersona_Click(sender As Object, e As EventArgs) Handles btnNuevaPersona.Click
        Response.Redirect("jdRegistrarPersona.aspx", False)
    End Sub

    Protected Sub btnNuevaEmpresa_Click(sender As Object, e As EventArgs) Handles btnNuevaEmpresa.Click
        Response.Redirect("jdRegistrarEmpresa.aspx", False)
    End Sub

    Protected Sub btnModificarPersona_Click(sender As Object, e As EventArgs) Handles btnModificarPersona.Click
        Response.Redirect("jdModificarPersona.aspx", False)
    End Sub

    Protected Sub btnModificarEmpresa_Click(sender As Object, e As EventArgs) Handles btnModificarEmpresa.Click
        ' Nota: en el escritorio este botón abre jdGestionarEmpresa.
        ' Esa pantalla no forma parte de este lote de migración; ajusta la ruta
        ' cuando generemos su versión web.
        Response.Redirect("jdGestionarEmpresa.aspx", False)
    End Sub

    ' =============================================
    ' LIMPIAR
    ' =============================================
    Protected Sub btnLimpiar_Click(sender As Object, e As EventArgs) Handles btnLimpiar.Click
        limpiarCampos()
        ocultarMensaje()
    End Sub

    Private Sub limpiarCamposPersona()
        txtNombreAp.Text = ""
        txtCorreo.Text = ""
        txtTelefono.Text = ""
    End Sub

    Private Sub limpiarCampos()
        txtDoc.Text = ""
        txtRUC.Text = ""
        txtNombreAp.Text = ""
        txtRazonSocial.Text = ""
        txtCorreo.Text = ""
        txtTelefono.Text = ""
        cboTipoDoc.SelectedIndex = 0
    End Sub

    ' =============================================
    ' MENSAJES DE ÉXITO / AVISO / ERROR
    ' =============================================
    Private Sub mostrarMensaje(texto As String, cssClass As String)
        lblMensaje.Text = texto
        lblMensaje.CssClass = "gc-alert " & cssClass
        lblMensaje.Visible = True
    End Sub

    Private Sub ocultarMensaje()
        lblMensaje.Text = ""
        lblMensaje.Visible = False
    End Sub

End Class