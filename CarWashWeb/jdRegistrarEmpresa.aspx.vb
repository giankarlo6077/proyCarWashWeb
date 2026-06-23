Imports System.Data
Imports capaNegocio

Public Class jdRegistrarEmpresa
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        If Not IsPostBack Then
            cargarDepartamentos()
            ocultarMensaje()
        End If
    End Sub

    ' =============================================
    ' CARGA UBIGEO
    ' =============================================
    Private Sub cargarDepartamentos()
        Dim objCliente As New clsCliente()
        Try
            Dim dt As DataTable = objCliente.listarDepartamentos()
            cboDepartamento.DataSource = dt
            cboDepartamento.DataTextField = "departamento"
            cboDepartamento.DataValueField = "iddepartamento"
            cboDepartamento.DataBind()
            cboDepartamento.Items.Insert(0, New ListItem("Seleccione...", ""))

            cboProvincia.Items.Clear()
            cboDistrito.Items.Clear()
        Catch ex As Exception
            mostrarMensaje("Error al cargar departamentos: " & ex.Message, "alert-danger")
        End Try
    End Sub

    Protected Sub cboDepartamento_SelectedIndexChanged(sender As Object, e As EventArgs) Handles cboDepartamento.SelectedIndexChanged
        cboProvincia.Items.Clear()
        cboDistrito.Items.Clear()

        If cboDepartamento.SelectedValue = "" Then Exit Sub

        Dim objCliente As New clsCliente()
        Try
            Dim idDepto As Integer = Convert.ToInt32(cboDepartamento.SelectedValue)
            Dim dt As DataTable = objCliente.listarProvincias(idDepto)
            cboProvincia.DataSource = dt
            cboProvincia.DataTextField = "provincia"
            cboProvincia.DataValueField = "idprovincia"
            cboProvincia.DataBind()
            cboProvincia.Items.Insert(0, New ListItem("Seleccione...", ""))
        Catch ex As Exception
            mostrarMensaje("Error al cargar provincias: " & ex.Message, "alert-danger")
        End Try
    End Sub

    Protected Sub cboProvincia_SelectedIndexChanged(sender As Object, e As EventArgs) Handles cboProvincia.SelectedIndexChanged
        cboDistrito.Items.Clear()

        If cboProvincia.SelectedValue = "" Then Exit Sub

        Dim objCliente As New clsCliente()
        Try
            Dim idProv As Integer = Convert.ToInt32(cboProvincia.SelectedValue)
            Dim dt As DataTable = objCliente.listarDistritos(idProv)
            cboDistrito.DataSource = dt
            cboDistrito.DataTextField = "distrito"
            cboDistrito.DataValueField = "iddistrito"
            cboDistrito.DataBind()
            cboDistrito.Items.Insert(0, New ListItem("Seleccione...", ""))
        Catch ex As Exception
            mostrarMensaje("Error al cargar distritos: " & ex.Message, "alert-danger")
        End Try
    End Sub

    ' =============================================
    ' BOTÓN GUARDAR
    ' =============================================
    Protected Sub btnGuardar_Click(sender As Object, e As EventArgs) Handles btnGuardar.Click

        ' Validaciones obligatorias (idénticas al escritorio)
        If txtRazonSocial.Text.Trim() = "" Then
            mostrarMensaje("Ingrese la razón social.", "alert-warning")
            Exit Sub
        End If

        If txtRUC.Text.Trim() = "" OrElse txtRUC.Text.Trim().Length <> 11 Then
            mostrarMensaje("Ingrese un RUC válido (11 dígitos).", "alert-warning")
            Exit Sub
        End If

        If txtDireccion.Text.Trim() = "" Then
            mostrarMensaje("Ingrese la dirección.", "alert-warning")
            Exit Sub
        End If

        If cboDistrito.SelectedValue = "" Then
            mostrarMensaje("Seleccione un distrito.", "alert-warning")
            Exit Sub
        End If

        Dim objCliente As New clsCliente()
        Dim objEmpresa As New clsEmpresa()
        Try
            ' 1. Insertar en CLIENTE y obtener el ID generado
            Dim idCliente As Integer = objCliente.registrarClienteEmpresa(
                txtRUC.Text.Trim(),
                txtDireccion.Text.Trim(),
                txtCorreo.Text.Trim(),
                txtTelefono.Text.Trim(),
                Convert.ToInt32(cboDistrito.SelectedValue)
            )

            ' 2. Insertar en EMPRESA con el idCliente obtenido
            objEmpresa.registrarEmpresa(
                txtRazonSocial.Text.Trim(),
                txtRUC.Text.Trim(),
                idCliente
            )

            mostrarMensaje("Empresa registrada correctamente.", "alert-success")
            limpiarCampos()

        Catch ex As Exception
            mostrarMensaje("Error: " & ex.Message, "alert-danger")
        End Try
    End Sub

    ' =============================================
    ' BOTÓN CANCELAR
    ' =============================================
    Protected Sub btnCancelar_Click(sender As Object, e As EventArgs) Handles btnCancelar.Click
        Response.Redirect("~/jdGestionarClientes.aspx", False)
    End Sub

    ' =============================================
    ' LIMPIAR CAMPOS
    ' =============================================
    Private Sub limpiarCampos()
        txtRazonSocial.Text = ""
        txtRUC.Text = ""
        txtTelefono.Text = ""
        txtCorreo.Text = ""
        txtDireccion.Text = ""
        cargarDepartamentos()
    End Sub

    ' =============================================
    ' MENSAJES DE ÉXITO / AVISO / ERROR
    ' =============================================
    Private Sub mostrarMensaje(texto As String, cssClass As String)
        lblMensaje.Text = texto
        lblMensaje.CssClass = "re-alert " & cssClass
        lblMensaje.Visible = True
    End Sub

    Private Sub ocultarMensaje()
        lblMensaje.Text = ""
        lblMensaje.Visible = False
    End Sub

End Class