Imports System.Data
Imports capaNegocio

Partial Class jdGestionarDescuento
    Inherits System.Web.UI.Page

    Dim objDescuento As New clsDescuento()
    Dim objTipoDescuento As New clsTipoDescuento()

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            Try
                CargarComboTipo()
                Listar()
                Limpiar()
            Catch ex As Exception
                MostrarError("Error al cargar la página: " & ex.Message)
            End Try
        End If
    End Sub

    ' ================================================================
    ' MÉTODOS DE APOYO
    ' ================================================================
    Private Sub CargarComboTipo()
        Try
            Dim dt As DataTable = objTipoDescuento.listar()
            cboTipoDescuento.DataSource = dt
            cboTipoDescuento.DataTextField = "tipoDescuento"
            cboTipoDescuento.DataValueField = "idTipoDescuento"
            cboTipoDescuento.DataBind()
            cboTipoDescuento.Items.Insert(0, New ListItem("-- Seleccione --", "0"))
        Catch ex As Exception
            MostrarError("Error al cargar Tipos de Descuento.")
        End Try
    End Sub

    Private Sub Listar()
        Try
            Dim dt As DataTable = objDescuento.listar()
            dgvDescuentos.DataSource = dt
            dgvDescuentos.DataBind()
        Catch ex As Exception
            MostrarError("Error al listar los descuentos.")
        End Try
    End Sub

    Private Sub Limpiar()
        hdnIdDescuento.Value = "0"
        txtID.Text = ""
        txtCodigo.Text = ""
        cboAplicaA.SelectedIndex = 0
        txtDescripcion.Text = ""
        txtValor.Text = ""
        cboTipoDescuento.SelectedIndex = 0
        txtFechaInicio.Text = DateTime.Now.ToString("yyyy-MM-dd")
        txtFechaFin.Text = DateTime.Now.ToString("yyyy-MM-dd")
        chkActivo.Checked = False
        lblMensaje.Text = ""
    End Sub

    Private Sub MostrarError(mensaje As String)
        lblMensaje.Text = mensaje
        lblMensaje.ForeColor = System.Drawing.Color.Red
    End Sub

    Private Sub MostrarExito(mensaje As String)
        lblMensaje.Text = mensaje
        lblMensaje.ForeColor = System.Drawing.Color.Green
    End Sub

    ' ================================================================
    ' LÓGICA DE BÚSQUEDA Y SELECCIÓN
    ' ================================================================
    Protected Sub dgvDescuentos_RowCommand(sender As Object, e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles dgvDescuentos.RowCommand
        If e.CommandName = "Seleccionar" Then
            Dim idSel As Integer = Convert.ToInt32(e.CommandArgument)
            hdnIdDescuento.Value = idSel.ToString()
            txtID.Text = idSel.ToString()

            Try
                Dim dt As DataTable = objDescuento.listar()
                For Each row As DataRow In dt.Rows
                    If Convert.ToInt32(row("ID")) = idSel Then
                        txtCodigo.Text = row("Codigo").ToString()
                        txtDescripcion.Text = row("Descripcion").ToString()
                        txtValor.Text = row("Valor").ToString()

                        If cboAplicaA.Items.FindByValue(row("Aplica a").ToString()) IsNot Nothing Then
                            cboAplicaA.ClearSelection()
                            cboAplicaA.Items.FindByValue(row("Aplica a").ToString()).Selected = True
                        End If

                        If cboTipoDescuento.Items.FindByText(row("Tipo de descuento").ToString()) IsNot Nothing Then
                            cboTipoDescuento.ClearSelection()
                            cboTipoDescuento.Items.FindByText(row("Tipo de descuento").ToString()).Selected = True
                        End If

                        If Not IsDBNull(row("Fecha inicio")) Then
                            txtFechaInicio.Text = Convert.ToDateTime(row("Fecha inicio")).ToString("yyyy-MM-dd")
                        End If
                        If Not IsDBNull(row("Fecha fin")) Then
                            txtFechaFin.Text = Convert.ToDateTime(row("Fecha fin")).ToString("yyyy-MM-dd")
                        End If

                        chkActivo.Checked = Convert.ToBoolean(row("estado"))
                        MostrarExito("Descuento cargado para editar.")
                        Exit For
                    End If
                Next
            Catch ex As Exception
                MostrarError("Error al cargar los datos del descuento.")
            End Try
        End If
    End Sub

    Protected Sub btnBuscar_Click(sender As Object, e As EventArgs) Handles btnBuscar.Click
        EjecutarBusqueda()
    End Sub

    Protected Sub txtBuscar_TextChanged(sender As Object, e As EventArgs) Handles txtBuscar.TextChanged
        If String.IsNullOrWhiteSpace(txtBuscar.Text) Then
            Listar()
            lblMensaje.Text = ""
        End If
    End Sub

    Private Sub EjecutarBusqueda()
        Try
            If String.IsNullOrWhiteSpace(txtBuscar.Text) Then
                Listar()
            Else
                Dim dt As DataTable = objDescuento.listar()
                Dim dv As New DataView(dt)
                dv.RowFilter = "Codigo LIKE '%" & txtBuscar.Text.Trim() & "%'"
                dgvDescuentos.DataSource = dv
                dgvDescuentos.DataBind()
            End If
            lblMensaje.Text = ""
        Catch ex As Exception
            MostrarError("Error al realizar la búsqueda.")
        End Try
    End Sub

    ' ================================================================
    ' BOTONERA DE ACCIONES
    ' ================================================================
    Protected Sub btnNuevo_Click(sender As Object, e As EventArgs) Handles btnNuevo.Click
        Limpiar()
        Try
            Dim nuevoID As Integer = objDescuento.obtenerNuevoID()
            hdnIdDescuento.Value = nuevoID.ToString()
            txtID.Text = nuevoID.ToString()
            MostrarExito("Listo para guardar un nuevo descuento.")
        Catch ex As Exception
            MostrarError("Error al generar nuevo ID.")
        End Try
    End Sub

    Protected Sub btnGuardar_Click(sender As Object, e As EventArgs) Handles btnGuardar.Click
        If hdnIdDescuento.Value = "0" Or txtID.Text = "" Then
            MostrarError("Debe generar un NUEVO registro antes de guardar.")
            Return
        End If

        Try
            Dim v As Decimal = Convert.ToDecimal(txtValor.Text)
            Dim fechaIni As DateTime = Convert.ToDateTime(txtFechaInicio.Text)
            Dim fechaFin As DateTime = Convert.ToDateTime(txtFechaFin.Text)

            ' Corrección: Usamos .SelectedValue para asegurar compatibilidad web
            objDescuento.registrar(Convert.ToInt32(hdnIdDescuento.Value), txtCodigo.Text, txtDescripcion.Text, v,
                                   Convert.ToInt32(cboTipoDescuento.SelectedValue), cboAplicaA.SelectedValue,
                                   fechaIni, fechaFin, chkActivo.Checked)

            MostrarExito("Descuento guardado con éxito.")
            Limpiar()
            Listar()
        Catch ex As Exception
            MostrarError("Error al guardar: Verifique los datos (ej. formato del Valor).")
        End Try
    End Sub

    Protected Sub btnModificar_Click(sender As Object, e As EventArgs) Handles btnModificar.Click
        If hdnIdDescuento.Value = "0" Or txtID.Text = "" Then
            MostrarError("Debe seleccionar un descuento de la tabla para modificar.")
            Return
        End If

        Try
            Dim v As Decimal = Convert.ToDecimal(txtValor.Text)
            Dim fechaIni As DateTime = Convert.ToDateTime(txtFechaInicio.Text)
            Dim fechaFin As DateTime = Convert.ToDateTime(txtFechaFin.Text)

            objDescuento.modificar(Convert.ToInt32(hdnIdDescuento.Value), txtCodigo.Text, txtDescripcion.Text, v,
                                   Convert.ToInt32(cboTipoDescuento.SelectedValue), cboAplicaA.SelectedValue,
                                   fechaIni, fechaFin, chkActivo.Checked)

            MostrarExito("Descuento modificado con éxito.")
            Limpiar()
            Listar()
        Catch ex As Exception
            MostrarError("Error al modificar: Verifique los datos.")
        End Try
    End Sub

    Protected Sub btnDarDeBaja_Click(sender As Object, e As EventArgs) Handles btnDarDeBaja.Click
        If hdnIdDescuento.Value = "0" Then
            MostrarError("Seleccione un descuento para dar de baja.")
            Return
        End If

        Try
            objDescuento.darDeBaja(Convert.ToInt32(hdnIdDescuento.Value))
            MostrarExito("Descuento dado de baja.")
            Limpiar()
            Listar()
        Catch ex As Exception
            MostrarError("Error al dar de baja.")
        End Try
    End Sub

    Protected Sub btnLimpiar_Click(sender As Object, e As EventArgs) Handles btnLimpiar.Click
        Limpiar()
        MostrarExito("Formulario limpiado.")
        lblMensaje.ForeColor = System.Drawing.Color.Black
    End Sub

End Class