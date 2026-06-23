Imports System.Data
Imports capaNegocio

Public Class jdRegistrarPersona
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        If Not IsPostBack Then
            txtFecha.Text = Date.Now.ToString("dd/MM/yyyy")
            txtFechaNac.Text = Date.Now.ToString("yyyy-MM-dd")
            cargarDepartamentos()
            cargarListView()
            ocultarMensaje()
        End If
    End Sub

    ' =============================================
    ' UBIGEO EN CASCADA
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
    ' LISTADO DE PERSONAS (vista de referencia)
    ' =============================================
    Private Sub cargarListView()
        Dim objPersona As New clsPersona()
        Try
            Dim dt As DataTable = objPersona.listarPersona()
            gvPersonas.DataSource = dt
            gvPersonas.DataBind()
        Catch ex As Exception
            mostrarMensaje("Error al cargar personas: " & ex.Message, "alert-danger")
        End Try
    End Sub

    Protected Sub gvPersonas_SelectedIndexChanged(sender As Object, e As EventArgs) Handles gvPersonas.SelectedIndexChanged
        Dim row As GridViewRow = gvPersonas.SelectedRow
        If row Is Nothing Then Exit Sub

        txtId.Text = row.Cells(0).Text
        txtNombreAp.Text = row.Cells(1).Text
        txtDireccion.Text = row.Cells(3).Text
        txtCorreo.Text = row.Cells(4).Text
        txtTelefono.Text = row.Cells(5).Text

        If row.Cells(2).Text = "M" Then
            rbMasculino.Checked = True
            rbFemenino.Checked = False
        Else
            rbFemenino.Checked = True
            rbMasculino.Checked = False
        End If
    End Sub

    ' =============================================
    ' GENERAR ID DE PREVISUALIZACIÓN
    ' =============================================
    Private Sub cargarIdCliente()
        Dim objPersona As New clsPersona()
        Try
            txtId.Text = objPersona.generarIdPersona().ToString()
        Catch ex As Exception
            mostrarMensaje("Error al generar ID: " & ex.Message, "alert-danger")
        End Try
    End Sub

    ' =============================================
    ' BOTÓN NUEVO / GUARDAR
    ' =============================================
    Protected Sub btnNuevo_Click(sender As Object, e As EventArgs) Handles btnNuevo.Click

        If btnNuevo.Text = "Nuevo" Then
            limpiarCampos()
            cargarIdCliente()
            btnNuevo.Text = "Guardar"
            Exit Sub
        End If

        ' btnNuevo.Text = "Guardar" -> validar y registrar
        If txtNombreAp.Text.Trim() = "" OrElse txtDNI.Text.Trim() = "" Then
            mostrarMensaje("Complete los campos obligatorios.", "alert-warning")
            Exit Sub
        End If

        If cboDistrito.SelectedValue = "" Then
            mostrarMensaje("Seleccione un distrito.", "alert-warning")
            Exit Sub
        End If

        If Not rbMasculino.Checked AndAlso Not rbFemenino.Checked Then
            mostrarMensaje("Seleccione el sexo.", "alert-warning")
            Exit Sub
        End If

        Dim fechaNacimiento As Date
        If Not Date.TryParse(txtFechaNac.Text, fechaNacimiento) Then
            mostrarMensaje("Ingrese una fecha de nacimiento válida.", "alert-warning")
            Exit Sub
        End If

        Dim fechaActual As Date = Date.Today
        Dim edad As Integer = fechaActual.Year - fechaNacimiento.Year
        If fechaNacimiento > fechaActual.AddYears(-edad) Then
            edad -= 1
        End If

        If fechaNacimiento > fechaActual Then
            mostrarMensaje("La fecha de nacimiento no puede ser una fecha futura.", "alert-warning")
            Exit Sub
        End If

        If edad < 18 Then
            mostrarMensaje("La persona debe ser mayor de edad (mínimo 18 años).", "alert-warning")
            Exit Sub
        End If

        Dim sexo As String = If(rbMasculino.Checked, "M", "F")

        Dim objPersona As New clsPersona()
        Try
            Dim idCli As Integer = Convert.ToInt32(txtId.Text)
            Dim idPer As Integer = Convert.ToInt32(txtId.Text)
            Dim idDis As Integer = Convert.ToInt32(cboDistrito.SelectedValue)

            objPersona.registrarPersona(
                idCli,
                idPer,
                txtNombreAp.Text.Trim(),
                txtDireccion.Text.Trim(),
                txtCorreo.Text.Trim(),
                txtTelefono.Text.Trim(),
                sexo,
                Date.Now,
                idDis,
                fechaNacimiento,
                txtDNI.Text.Trim()
            )

            mostrarMensaje("Persona registrada correctamente.", "alert-success")

            limpiarCampos()
            cargarListView()
            btnNuevo.Text = "Nuevo"

        Catch ex As Exception
            mostrarMensaje("Error al registrar: " & ex.Message, "alert-danger")
        End Try
    End Sub

    Protected Sub btnCancelar_Click(sender As Object, e As EventArgs) Handles btnCancelar.Click
        limpiarCampos()
        ocultarMensaje()
    End Sub

    Private Sub limpiarCampos()
        txtNombreAp.Text = ""
        txtDNI.Text = ""
        txtDireccion.Text = ""
        txtCorreo.Text = ""
        txtTelefono.Text = ""
        rbMasculino.Checked = False
        rbFemenino.Checked = False
        txtFecha.Text = Date.Now.ToString("dd/MM/yyyy")
        txtFechaNac.Text = Date.Now.ToString("yyyy-MM-dd")
        cboDepartamento.SelectedIndex = 0
        cboProvincia.Items.Clear()
        cboDistrito.Items.Clear()
        btnNuevo.Text = "Nuevo"
        txtId.Text = ""
    End Sub

    ' =============================================
    ' MENSAJES DE ÉXITO / AVISO / ERROR
    ' =============================================
    Private Sub mostrarMensaje(texto As String, cssClass As String)
        lblMensaje.Text = texto
        lblMensaje.CssClass = "rp-alert " & cssClass
        lblMensaje.Visible = True
    End Sub

    Private Sub ocultarMensaje()
        lblMensaje.Text = ""
        lblMensaje.Visible = False
    End Sub

End Class