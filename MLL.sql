------------------------------------------------------------------------------------------------------------------------------------
--1
--Done


CREATE VIEW internal_wms.vw_aging_invoice_report AS
    SELECT 
        res.ITEM_CODE AS ITEM_CODE,
        res.ITEM_NAME AS ITEM_NAME,
        res.UOM_CODE AS UOM_CODE,
        res.UOM_DESC AS UOM_DESC,
        res.ITEM_STATUS_CODE AS ITEM_STATUS_CODE,
        res.ITEM_STATUS_DESC AS ITEM_STATUS_DESC,
        res.PACK_UOM AS PACK_UOM,
        res.PACK_UOM_DESC AS PACK_UOM_DESC,
        SUM(res.BUCKET_1) AS '0-30',
        SUM(res.BUCKET_2) AS '31-60',
        SUM(res.BUCKET_3) AS '61-90',
        SUM(res.BUCKET_4) AS '91-120',
        SUM(res.BUCKET_5) AS '121-180',
        SUM(res.BUCKET_6) AS MORE_THAN_180,
        res.COMPANY_ID AS COMPANY_ID,
        res.WAREHOUSE_ID AS WAREHOUSE_ID,
        res.USER_ID AS USER_ID
    FROM
        (SELECT 
            i.item_name AS ITEM_NAME,
                u.uom_code AS UOM_CODE,
                u.uom_desc AS UOM_DESC,
                its.item_status_code AS ITEM_STATUS_CODE,
                its.item_status_desc AS ITEM_STATUS_DESC,
                ISNULL(pu.uom_code, '') AS PACK_UOM,
                ISNULL(pu.uom_desc, '') AS PACK_UOM_DESC,
                IIF(((il.item_component_code IS NOT NULL)
                    AND (il.item_component_code <> '')), il.item_component_code, il.item_code) AS ITEM_CODE,
                (CASE
                    WHEN (DATEDIFF(d,SYSDATETIME(),ilib.invoice_date) BETWEEN 0 AND 30) THEN il.onhand_qty
                    ELSE 0
                END) AS BUCKET_1,
                (CASE
                    WHEN (DATEDIFF(d,SYSDATETIME(),ilib.invoice_date) BETWEEN 31 AND 60) THEN il.onhand_qty
                    ELSE 0
                END) AS BUCKET_2,
                (CASE
                    WHEN (DATEDIFF(d,SYSDATETIME(),ilib.invoice_date) BETWEEN 61 AND 90) THEN il.onhand_qty
                    ELSE 0
                END) AS BUCKET_3,
                (CASE
                    WHEN (DATEDIFF(d,SYSDATETIME(),ilib.invoice_date) BETWEEN 91 AND 120) THEN il.onhand_qty
                    ELSE 0
                END) AS BUCKET_4,
                (CASE
                    WHEN (DATEDIFF(d,SYSDATETIME(),ilib.invoice_date) BETWEEN 121 AND 180) THEN il.onhand_qty
                    ELSE 0
                END) AS BUCKET_5,
                (CASE
                    WHEN (DATEDIFF(d,SYSDATETIME(),ilib.invoice_date) > 180) THEN il.onhand_qty
                    ELSE 0
                END) AS BUCKET_6,
                il.company_id AS COMPANY_ID,
                il.warehouse_id AS WAREHOUSE_ID,
                uwm.user_id AS USER_ID
        FROM
            (((((((internal_wms.invty_location_inventory il
        JOIN internal_wms.invty_location_inventory_ibdetail ilib ON ((ilib.li_id = il.li_id)))
        JOIN internal_wms.mst_uom u ON ((u.uom_id = il.uom_id)))
        JOIN internal_wms.mst_item i ON (((i.item_code = il.item_code)
            AND (i.company_id = il.company_id))))
        JOIN internal_wms.mst_item_status its ON (((its.company_id = il.company_id)
            AND (its.item_status_id = il.item_status_id))))
        JOIN internal_wms.ac_user_warehouse_map uwm ON (((uwm.warehouse_id = il.warehouse_id)
            AND (uwm.active = 'A'))))
        JOIN internal_wms.mst_location l ON (((l.location_code = il.location_code)
            AND (il.warehouse_id = l.warehouse_id))))
        LEFT JOIN internal_wms.mst_uom pu ON ((pu.uom_id = il.pack_uom_id)))
        WHERE
            ((il.onhand_qty > 0)
                AND (l.location_type_id IN (1 , 2, 6, 7, 8, 9)))) res
    GROUP BY res.ITEM_CODE , res.ITEM_NAME , res.UOM_CODE , res.UOM_DESC , res.ITEM_STATUS_CODE , res.ITEM_STATUS_DESC , res.PACK_UOM , res.PACK_UOM_DESC, res.COMPANY_ID, res.WAREHOUSE_ID, res.USER_ID

------------------------------------------------------------------------------------------------------------------------------------------
--2
--Done

CREATE VIEW internal_wms.vw_aging_mfg_date_report AS
    SELECT
        res.ITEM_CODE AS ITEM_CODE,
        res.ITEM_NAME AS ITEM_NAME,
        res.UOM_CODE AS UOM_CODE,
        res.UOM_DESC AS UOM_DESC,
        res.ITEM_STATUS_CODE AS ITEM_STATUS_CODE,
        res.ITEM_STATUS_DESC AS ITEM_STATUS_DESC,
        res.PACK_UOM AS PACK_UOM,
        res.PACK_UOM_DESC AS PACK_UOM_DESC,
        SUM(res.BUCKET_1) AS '0-30',
        SUM(res.BUCKET_2) AS '31-60',
        SUM(res.BUCKET_3) AS '61-90',
        SUM(res.BUCKET_4) AS '91-120',
        SUM(res.BUCKET_5) AS '121-180',
        SUM(res.BUCKET_6) AS MORE_THAN_180,
        res.COMPANY_ID AS COMPANY_ID,
        res.WAREHOUSE_ID AS WAREHOUSE_ID,
        res.USER_ID AS USER_ID
    FROM
        (SELECT
            i.item_name AS ITEM_NAME,
                u.uom_code AS UOM_CODE,
                u.uom_desc AS UOM_DESC,
                its.item_status_code AS ITEM_STATUS_CODE,
                its.item_status_desc AS ITEM_STATUS_DESC,
                ISNULL(pu.uom_code, '') AS PACK_UOM,
                ISNULL(pu.uom_desc, '') AS PACK_UOM_DESC,
                IIF(((il.item_component_code IS NOT NULL)
                    AND (il.item_component_code <> '')), il.item_component_code, il.item_code) AS ITEM_CODE,
                (CASE
                    WHEN (DATEDIFF(d,SYSDATETIME(),il.mfg_date) BETWEEN 0 AND 30) THEN il.onhand_qty
                    ELSE 0
                END) AS BUCKET_1,
                (CASE
                    WHEN (DATEDIFF(d,SYSDATETIME(),il.mfg_date) BETWEEN 31 AND 60) THEN il.onhand_qty
                    ELSE 0
                END) AS BUCKET_2,
                (CASE
                    WHEN (DATEDIFF(d,SYSDATETIME(),il.mfg_date) BETWEEN 61 AND 90) THEN il.onhand_qty
                    ELSE 0
                END) AS BUCKET_3,
                (CASE
                    WHEN (DATEDIFF(d,SYSDATETIME(),il.mfg_date) BETWEEN 91 AND 120) THEN il.onhand_qty
                    ELSE 0
                END) AS BUCKET_4,
                (CASE
                    WHEN (DATEDIFF(d,SYSDATETIME(),il.mfg_date) BETWEEN 121 AND 180) THEN il.onhand_qty
                    ELSE 0
                END) AS BUCKET_5,
                (CASE
                    WHEN (DATEDIFF(d,SYSDATETIME(),il.mfg_date) > 180) THEN il.onhand_qty
                    ELSE 0
                END) AS BUCKET_6,
                il.company_id AS COMPANY_ID,
                il.warehouse_id AS WAREHOUSE_ID,
                uwm.user_id AS USER_ID
        FROM
            ((((((internal_wms.invty_location_inventory il
        JOIN internal_wms.mst_uom u ON ((u.uom_id = il.uom_id)))
        JOIN internal_wms.mst_item i ON (((i.item_code = il.item_code)
            AND (i.company_id = il.company_id))))
        JOIN internal_wms.mst_item_status its ON (((its.company_id = il.company_id)
            AND (its.item_status_id = il.item_status_id))))
        JOIN internal_wms.ac_user_warehouse_map uwm ON (((uwm.warehouse_id = il.warehouse_id)
            AND (uwm.active = 'A'))))
        JOIN internal_wms.mst_location l ON (((l.location_code = il.location_code)
            AND (il.warehouse_id = l.warehouse_id))))
        LEFT JOIN internal_wms.mst_uom pu ON ((pu.uom_id = il.pack_uom_id)))
        WHERE
            ((il.onhand_qty > 0)
                AND (l.location_type_id IN (1 , 2, 6, 7, 8, 9))
                AND (il.mfg_date > '2000-01-01 00:00:00'))) res
    GROUP BY res.ITEM_CODE , res.ITEM_NAME , res.UOM_CODE , res.UOM_DESC , res.ITEM_STATUS_CODE , res.ITEM_STATUS_DESC , res.PACK_UOM , res.PACK_UOM_DESC, res.COMPANY_ID, res.WAREHOUSE_ID, res.USER_ID

-------------------------------------------------------------------------------------------------------------------------------------------
--3
--Done

CREATE VIEW internal_wms.vw_cc_report AS
    SELECT
        t.task_id AS TASK_ID,
        t.task_code AS TASK_CODE,
        t.tran_id AS TRAN_ID,
        t.cc_id AS CC_ID,
        t.li_id AS LI_ID,
        t.company_id AS COMPANY_ID,
        t.warehouse_id AS WAREHOUSE_ID,
        t.item_code AS ITEM_CODE,
        ISNULL(i.item_name, '') AS ITEM_NAME,
        t.receipt_date AS RECEIPT_DATE,
        t.mfg_date AS MFG_DATE,
        t.exp_date AS EXP_DATE,
        t.base_uom_id AS BASE_UOM_ID,
        t.uom_id AS UOM_ID,
        ISNULL(u.uom_code, '') AS UOM_CODE,
        t.pack_uom_id AS PACK_UOM_ID,
        t.inner_pack_uom_id AS INNER_PACK_UOM_ID,
        t.onhand_qty AS ONHAND_QTY,
        t.reserved_qty AS RESERVED_QTY,
        t.available_qty AS AVAILABLE_QTY,
        t.onhold_qty AS ONHOLD_QTY,
        t.scan_qty AS SCAN_QTY,
        t.actual_qty AS ACTUAL_QTY,
        t.hz_group_code AS HZ_GROUP_CODE,
        t.home_zone_code AS HOME_ZONE_CODE,
        t.home_subzone_code AS HOME_SUBZONE_CODE,
        t.location_code AS LOCATION_CODE,
        t.item_status_id AS ITEM_STATUS_ID,
        t.item_mrp AS ITEM_MRP,
        t.item_cost AS ITEM_COST,
        t.box_code AS BOX_CODE,
        t.pallet_no AS PALLET_NO,
        t.batch_no AS BATCH_NO,
        t.serial_no AS SERIAL_NO,
        t.lot_no AS LOT_NO,
        t.lpn_no AS LPN_NO,
        t.color_code AS COLOR_CODE,
        t.item_size AS ITEM_SIZE,
        t.task_type AS TASK_TYPE,
        t.task_status AS TASK_STATUS,
        t.cc_assigned_to AS CC_ASSIGNED_TO,
        t.remarks AS REMARKS,
        th.is_offline_cc AS IS_OFFLINE_CC,
        th.cc_type AS CC_TYPE,
        td.is_last_touch AS IS_LAST_TOUCH,
        td.is_empty_location AS IS_EMPTY_LOCATION,
        th.cc_date AS CC_DATE,
        th.cc_code AS CC_CODE,
        t.remarks_1 AS REMARKS_1,
        ISNULL(ia.item_brand, '') AS BRAND_CODE,
        ISNULL(ia.item_subbrand, '') AS SUBBRAND_CODE,
        ISNULL(its.item_status_code, '') AS ITEM_STATUS_CODE,
        ISNULL(its.item_status_desc, '') AS ITEM_STATUS_DESC,
        ISNULL(ur.display_name, '') AS USER_DISPLAY_NAME,
        ch.cc_code AS CC_MASTER,
        ch.cc_description AS CC_DESCRIPTION,
        itc.category_code AS ITEM_CATEGORY_CODE,
        itg.item_group_code AS ITEM_GROUP_CODE,
        th.created_on AS CREATED_ON
    FROM
        ((((((((((internal_wms.cc_task t
        JOIN internal_wms.cc_tran_head th ON ((t.tran_id = th.tran_id)))
        JOIN internal_wms.cc_tran_detail td ON ((th.tran_id = td.tran_id)))
        JOIN internal_wms.cc_head ch ON ((ch.cc_id = th.cc_id)))
        LEFT JOIN internal_wms.mst_item i ON (((i.item_code = t.item_code)
            AND (i.company_id = t.company_id))))
        LEFT JOIN internal_wms.mst_uom u ON ((u.uom_id = t.uom_id)))
        LEFT JOIN internal_wms.mst_item_status its ON ((its.item_status_id = t.item_status_id)))
        LEFT JOIN internal_wms.mst_item_attributes ia ON (((ia.company_id = i.company_id)
            AND (ia.item_code = i.item_code))))
        LEFT JOIN internal_wms.mst_item_category itc ON (((itc.company_id = i.company_id)
            AND (itc.item_category_id = i.item_category_id))))
        LEFT JOIN internal_wms.mst_item_group itg ON (((itg.company_id = i.company_id)
            AND (itg.item_group_id = i.item_group_id))))
        LEFT JOIN internal_wms.ac_user ur ON ((ur.user_id = t.cc_assigned_to)))
------------------------------------------------------------------------------------------------------------------------------------------
--4
--Done

CREATE
VIEW internal_wms.vw_dock_report AS
    SELECT
        dt.tran_id AS TRAN_ID,
        dt.gate_pass_code AS GATE_PASS_CODE,
        dt.dock_id AS DOCK_ID,
        dt.hub_name AS HUB_NAME,
        dt.ba_id AS BA_ID,
        dt.vehicle_type AS VEHICLE_TYPE,
        dt.vehicle_no AS VEHICLE_NO,
        dt.driver_name AS DRIVER_NAME,
        dt.driver_mobile_no AS DRIVER_MOBILE_NO,
        dt.vehicle_rc_no AS VEHICLE_RC_NO,
        dt.permit_details AS PERMIT_DETAILS,
        dt.no_of_invoices AS NO_OF_INVOICES,
        dt.no_of_boxes AS NO_OF_BOXES,
        dt.total_weight AS TOTAL_WEIGHT,
        dt.reported_for AS REPORTED_FOR,
        dt.yard_id AS YARD_ID,
        dt.reported_date AS REPORTED_DATE,
        dt.gatein_date AS GATEIN_DATE,
        dt.dockin_date AS DOCKIN_DATE,
        dt.dockout_date AS DOCKOUT_DATE,
        dt.gateout_date AS GATEOUT_DATE,
        dt.sys_reported_date AS SYS_REPORTED_DATE,
        dt.sys_gatein_date AS SYS_GATEIN_DATE,
        dt.sys_dockin_date AS SYS_DOCKIN_DATE,
        dt.sys_dockout_date AS SYS_DOCKOUT_DATE,
        dt.sys_gateout_date AS SYS_GATEOUT_DATE,
        md.dock_code AS DOCK_CODE,
        ba.ba_name AS BA_NAME,
        ba.ba_code AS BA_CODE,
        ISNULL(yd.dock_code, '') AS YARD_CODE,
        (CASE dt.status
            WHEN 'REPORTED' THEN 'REPORTED'
            WHEN 'GATEIN' THEN 'GATE IN'
            WHEN 'DOCKIN' THEN 'DOCK IN'
            WHEN 'DOCKOUT' THEN 'DOCK OUT'
            WHEN 'GATEOUT' THEN 'GATE OUT'
            ELSE 'TERMINATED'
        END) AS STATUS,
        DATEDIFF(minute,IIF((CAST(dt.gatein_date AS DATE) = '2000-01-01'),
                    NULL,
                    dt.gatein_date),
                IIF((CAST(dt.reported_date AS DATE) = '2000-01-01'),
                    NULL,
                    dt.reported_date)) AS REP_GIN_TIME,
        DATEDIFF(minute,IIF((CAST(dt.dockin_date AS DATE) = '2000-01-01'),
                    NULL,
                    dt.dockin_date),
                IIF((CAST(dt.gatein_date AS DATE) = '2000-01-01'),
                    NULL,
                    dt.gatein_date)) AS GIN_DIN_TIME,
        DATEDIFF(minute,IIF((CAST(dt.dockout_date AS DATE) = '2000-01-01'),
                    NULL,
                    dt.dockout_date),
                IIF((CAST(dt.dockin_date AS DATE) = '2000-01-01'),
                    NULL,
                    dt.dockin_date)) AS UNLOADING_TIME,
        DATEDIFF(minute, IIF((CAST(dt.gateout_date AS DATE) = '2000-01-01'),
                    NULL,
                    dt.gateout_date),
                IIF((CAST(dt.dockout_date AS DATE) = '2000-01-01'),
                    NULL,
                    dt.dockout_date)) AS DOUT_GOUT_TIME,
        DATEDIFF(minute, IIF((CAST(dt.gateout_date AS DATE) = '2000-01-01'),
                    NULL,
                    dt.gateout_date),
                IIF((CAST(dt.gatein_date AS DATE) = '2000-01-01'),
                    NULL,
                    dt.gatein_date)) AS RETENTION_TIME,
        DATEDIFF(minute, IIF((CAST(dt.gateout_date AS DATE) = '2000-01-01'),
                    NULL,
                    dt.gateout_date),
                IIF((CAST(dt.reported_date AS DATE) = '2000-01-01'),
                    NULL,
                    dt.reported_date)) AS REP_GOUT_TIME,
        dt.company_id AS COMPANY_ID,
        dt.warehouse_id AS WAREHOUSE_ID,
        dt.created_on AS CREATED_ON
    FROM
        (((internal_wms.dock_trans dt
        JOIN internal_wms.mst_dock md ON ((md.dock_id = dt.dock_id)))
        JOIN internal_wms.mst_ba ba ON ((ba.ba_id = dt.ba_id)))
        LEFT JOIN internal_wms.mst_dock yd ON ((yd.dock_id = dt.yard_id)))
    ORDER BY dt.tran_id DESC OFFSET 0 ROWS
----------------------------------------------------------------------------------------------------------------------------------------
--5
--done

alter VIEW internal_wms.vw_grnconf_report AS
    SELECT
        g.grn_code AS GRN_CODE,
        g.grn_type AS GRN_TYPE,
        FORMAT(g.grn_date, 'yyyy-MM-dd HH:mm:ss') AS GRN_DATE,
        g.supplier_order_no AS SUPPLIER_ORDER_NO,
        g.invoice_no AS INVOICE_NO,
        g.invoice_value AS INVOICE_VALUE,
        FORMAT(g.invoice_date, 'yyyy-MM-dd HH:mm:ss') AS INVOICE_DATE,
        g.vehicle_no AS VEHICLE_NO,
        g.dock_no AS DOCK_NO,
        FORMAT(g.created_on, 'yyyy-MM-dd HH:mm:ss') AS CREATED_ON,
        FORMAT(gc.ib_date, 'yyyy-MM-dd HH:mm:ss') AS IB_DATE,
        gc.ib_ref AS IB_REF,
        u.uom_code AS UOM_CODE,
        u.uom_desc AS UOM_DESC,
        ISNULL(pu.uom_code, '') AS PACK_UOM,
        its.item_status_desc AS ITEM_STATUS_DESC,
        ISNULL(pu.uom_desc, '') AS PACK_UOM_DESC,
        gc.grn_qty AS GRN_QTY,
        gc.confirm_qty AS CONFIRM_QTY,
        gc.pending_qty AS PENDING_QTY,
        gc.grn_status AS GRN_STATUS,
        gc.box_code AS BOX_CODE,
        gc.pallet_no AS PALLET_NO,
        gc.batch_no AS BATCH_NO,
        gc.serial_no AS SERIAL_NO,
        gc.lot_no AS LOT_NO,
        gc.lpn_no AS LPN_NO,
        FORMAT(gc.mfg_date, 'yyyy-MM-dd HH:mm:ss') AS MFG_DATE,
        FORMAT(gc.exp_date, 'yyyy-MM-dd HH:mm:ss') AS EXP_DATE,
        gc.colour_code AS COLOUR_CODE,
        gc.item_size AS ITEM_SIZE,
        gc.item_cost AS ITEM_COST,
        gc.item_mrp AS ITEM_MRP,
        gc.remarks AS REMARKS,
        i.item_name AS ITEM_NAME,
        ISNULL(ia.item_brand, '') AS BRAND_CODE,
        ISNULL(ia.item_subbrand, '') AS SUBBRAND_CODE,
        IIF(((gc.item_component_code IS NOT NULL)
                AND (gc.item_component_code <> '')),
            gc.item_component_code,
            gc.item_code) AS ITEM_CODE,
        pgd.hz_group AS HZ_GROUP_CODE,
        g.company_id AS COMPANY_ID,
        g.warehouse_id AS WAREHOUSE_ID,
        uwm.user_id AS USER_ID
    FROM
        (((((((((internal_wms.ib_grn g
        JOIN internal_wms.ib_grn_confirmation gc ON ((g.grn_number = gc.grn_number)))
        JOIN internal_wms.ib_grn_details gd ON ((gc.grn_details_id = gd.grn_details_id)))
        JOIN internal_wms.ib_pre_grn_details pgd ON ((pgd.ib_pre_grn_detail_id = gd.ib_pre_grn_detail_id)))
        JOIN internal_wms.mst_uom u ON ((u.uom_id = gc.uom_id)))
        JOIN internal_wms.mst_item i ON (((i.item_code = gc.item_code)
            AND (i.company_id = g.company_id))))
        JOIN internal_wms.mst_item_status its ON (((its.company_id = g.company_id)
            AND (its.item_status_id = gc.item_status_id))))
        JOIN internal_wms.ac_user_warehouse_map uwm ON (((uwm.warehouse_id = g.warehouse_id)
            AND (uwm.active = 'A'))))
        LEFT JOIN internal_wms.mst_uom pu ON ((pu.uom_id = gc.pack_uom_id)))
        LEFT JOIN internal_wms.mst_item_attributes ia ON (((ia.company_id = i.company_id)
            AND (ia.item_code = i.item_code))))
    WHERE
        (gc.grn_status <> 'GrnCan')
------------------------------------------------------------------------------------------------------------------------------------------
--6
--done

alter VIEW internal_wms.vw_grnr_eport AS
    SELECT
        g.grn_code AS GRN_CODE,
        g.grn_type AS GRN_TYPE,
        FORMAT(g.grn_date, 'yyyy-MM-dd HH:mm:ss') AS GRN_DATE,
        g.supplier_order_no AS SUPPLIER_ORDER_NO,
        g.invoice_no AS INVOICE_NO,
        g.invoice_value AS INVOICE_VALUE,
        FORMAT(g.invoice_date, 'yyyy-MM-dd HH:mm:ss') AS INVOICE_DATE,
        g.vehicle_no AS VEHICLE_NO,
        g.dock_no AS DOCK_NO,
        FORMAT(g.created_on, 'yyyy-MM-dd HH:mm:ss') AS CREATED_ON,
        FORMAT(gd.ib_date, 'yyyy-MM-dd HH:mm:ss') AS IB_DATE,
        gd.ib_ref AS IB_REF,
        u.uom_code AS UOM_CODE,
        u.uom_desc AS UOM_DESC,
        ISNULL(pu.uom_code, '') AS PACK_UOM,
        its.item_status_desc AS ITEM_STATUS_DESC,
        its.item_status_code AS ITEM_STATUS_CODE,
        ISNULL(pu.uom_desc, '') AS PACK_UOM_DESC,
        gd.grn_qty AS GRN_QTY,
        gd.confirm_qty AS CONFIRM_QTY,
        (gd.grn_qty - gd.confirm_qty) AS PENDING_QTY,
        gd.pallet_no AS PALLET_NO,
        gd.batch_no AS BATCH_NO,
        gd.serial_no AS SERIAL_NO,
        gd.lot_no AS LOT_NO,
        gd.lpn_no AS LPN_NO,
        gd.grn_status AS GRN_STATUS,
        FORMAT(gd.mfg_date, 'yyyy-MM-dd HH:mm:ss') AS MFG_DATE,
        FORMAT(gd.exp_date, 'yyyy-MM-dd HH:mm:ss') AS EXP_DATE,
        gd.colour_code AS COLOUR_CODE,
        gd.item_size AS ITEM_SIZE,
        gd.item_cost AS ITEM_COST,
        gd.item_mrp AS ITEM_MRP,
        gd.remarks AS REMARKS,
        i.item_name AS ITEM_NAME,
        ISNULL(ia.item_brand, '') AS BRAND_CODE,
        ISNULL(ia.item_subbrand, '') AS SUBBRAND_CODE,
        IIF(((gd.item_component_code IS NOT NULL)
                AND (gd.item_component_code <> '')),
            gd.item_component_code,
            gd.item_code) AS ITEM_CODE,
        pgd.hz_group AS HZ_GROUP_CODE,
        g.company_id AS COMPANY_ID,
        g.warehouse_id AS WAREHOUSE_ID,
        uwm.user_id AS USER_ID
    FROM
        (((((((internal_wms.ib_grn g
        JOIN internal_wms.ib_grn_details gd ON ((g.grn_number = gd.grn_number)))
        JOIN internal_wms.ib_pre_grn_details pgd ON ((pgd.ib_pre_grn_detail_id = gd.ib_pre_grn_detail_id)))
        JOIN internal_wms.mst_uom u ON ((u.uom_id = gd.uom_id)))
        JOIN internal_wms.mst_item i ON (((i.item_code = gd.item_code)
            AND (i.company_id = g.company_id))))
        JOIN internal_wms.mst_item_status its ON (((its.company_id = g.company_id
            AND (its.item_status_id = gd.item_status_id))))
        JOIN internal_wms.ac_user_warehouse_map uwm ON (((uwm.warehouse_id = g.warehouse_id)
            AND (uwm.active = 'A'))))
        LEFT JOIN internal_wms.mst_uom pu ON ((pu.uom_id = gd.pack_uom_id)))
        LEFT JOIN internal_wms.mst_item_attributes ia ON (((ia.company_id = i.company_id)
            AND (ia.item_code = i.item_code))))
    WHERE
        (gd.grn_status <> 'GrnCan')
---------------------------------------------------------------------------------------------------------------------------------------
--7
--Done

CREATE VIEW internal_wms.vw_itemledger_report AS
    SELECT
        o.order_date AS POSTING_DATE,
        'CUSTOMER' AS SOURCE_TYPE,
        c.customer_code AS SOURCE_CODE,
        c.customer_name AS SOURCE_NAME,
        'SALE' AS ENTRY_TYPE,
        'SALES SHIPMENT' AS DOCUMENT_TYPE,
        o.order_code AS DOCUMENT_NO,
        o.order_reference AS EXTERNAL_DOC_NO,
        od.item_code AS ITEM_CODE,
        i.item_name AS ITEM_NAME,
        (CASE
            WHEN (od.pending_qty = 0) THEN od.qty
            WHEN (od.qty <> od.pending_qty) THEN (od.qty - od.pending_qty)
            ELSE od.qty
        END) AS QUANTITY,
        us.display_name AS USER_NAME,
        od.batch_no AS BATCH_NO,
        od.serial_no AS SERIAL_NO,
        od.lot_no AS LOT_NO,
        od.lpn_no AS LPN_NO,
        u.uom_code AS UOM_CODE,
        its.item_status_code AS ITEM_STATUS_CODE,
        its.item_status_desc AS ITEM_STATUS_DESC,
        o.created_on AS CREATED_ON,
        o.company_id AS COMPANY_ID,
        o.warehouse_id AS WAREHOUSE_ID,
        uwm.user_id AS USER_ID
    FROM
        (((((((((((internal_wms.ob_order_details od
        JOIN internal_wms.ob_order_head o ON ((o.order_id = od.order_id)))
        JOIN internal_wms.mst_item i ON (((i.item_code = od.item_code)
            AND (i.company_id = o.company_id))))
        JOIN internal_wms.mst_uom u ON ((u.uom_id = od.uom_id)))
        JOIN internal_wms.mst_customer c ON (((c.customer_id = o.customer_id)
            AND (c.warehouse_id = o.warehouse_id))))
        JOIN internal_wms.ac_user_warehouse_map uwm ON (((uwm.warehouse_id = o.warehouse_id)
            AND (uwm.active = 'A'))))
        JOIN internal_wms.ac_user us ON ((us.user_id = o.created_by)))
        JOIN internal_wms.mst_city cy ON ((cy.city_id = o.ship_to_id)))
        JOIN internal_wms.mst_item_status its ON (((its.company_id = o.company_id)
            AND (its.item_status_id = od.item_status_id))))
        LEFT JOIN internal_wms.mst_route r ON (((r.route_id = o.route_id)
            AND (r.warehouse_id = o.warehouse_id))))
        LEFT JOIN internal_wms.mst_item_attributes ia ON (((ia.company_id = i.company_id)
            AND (ia.item_code = i.item_code))))
        LEFT JOIN internal_wms.mst_ba b ON ((b.ba_id = o.ba_id)))
    WHERE
        (od.order_status <> 'OrdCan')
    UNION ALL SELECT
        g.grn_date AS POSTING_DATE,
        'VENDOR' AS SOURCE_TYPE,
        s.supplier_code AS SOURCE_CODE,
        s.supplier_name AS SOURCE_NAME,
        'PURCHASE' AS ENTRY_TYPE,
        'PURCHASE SHIPMENT' AS DOCUMENT_TYPE,
        g.grn_code AS DOCUMENT_NO,
        g.invoice_no AS EXTERNAL_DOC_NO,
        gc.item_code AS ITEM_CODE,
        i.item_name AS ITEM_NAME,
        (CASE
            WHEN (gc.pending_qty = 0) THEN gc.confirm_qty
            WHEN (gc.confirm_qty <> gc.pending_qty) THEN gc.pending_qty
            ELSE gc.confirm_qty
        END) AS QUANTITY,
        us.display_name AS USER_NAME,
        gc.batch_no AS BATCH_NO,
        gc.serial_no AS SERIAL_NO,
        gc.lot_no AS LOT_NO,
        gc.lpn_no AS LPN_NO,
        u.uom_code AS UOM_CODE,
        its.item_status_code AS ITEM_STATUS_CODE,
        its.item_status_desc AS ITEM_STATUS_DESC,
        g.created_on AS CREATED_ON,
        g.company_id AS COMPANY_ID,
        g.warehouse_id AS WAREHOUSE_ID,
        uwm.user_id AS USER_ID
    FROM
        (((((((((internal_wms.ib_grn g
        JOIN internal_wms.ib_grn_confirmation gc ON ((g.grn_number = gc.grn_number)))
        JOIN internal_wms.mst_supplier s ON (((s.supplier_id = g.supplier_id)
            AND (s.warehouse_id = g.warehouse_id))))
        JOIN internal_wms.mst_uom u ON ((u.uom_id = gc.uom_id)))
        JOIN internal_wms.mst_item i ON (((i.item_code = gc.item_code)
            AND (i.company_id = g.company_id))))
        JOIN internal_wms.mst_item_status its ON (((its.company_id = g.company_id)
            AND (its.item_status_id = gc.item_status_id))))
        JOIN internal_wms.ac_user_warehouse_map uwm ON (((uwm.warehouse_id = g.warehouse_id)
            AND (uwm.active = 'A'))))
        JOIN internal_wms.ac_user us ON ((us.user_id = g.created_by)))
        LEFT JOIN internal_wms.mst_uom pu ON ((pu.uom_id = gc.pack_uom_id)))
        LEFT JOIN internal_wms.mst_item_attributes ia ON (((ia.company_id = i.company_id)
            AND (ia.item_code = i.item_code))))
    WHERE
        (gc.grn_status <> 'GrnCan'
------------------------------------------------------------------------------------------------------------------------------------------
--8
--Done

CREATE VIEW internal_wms.vw_kit_report AS
    SELECT
        p.pick_id AS PICK_ID,
        k.kit_id AS KIT_ID,
        k.kit_code AS KIT_CODE,
        k.kit_date AS KIT_DATE,
        p.pick_code AS PICK_CODE,
        p.company_id AS COMPANY_ID,
        c.company_code AS COMPANY_CODE,
        c.company_name AS COMPANY_NAME,
        p.warehouse_id AS WAREHOUSE_ID,
        w.warehouse_code AS WAREHOUSE_CODE,
        w.warehouse_name AS WAREHOUSE_NAME,
        p.pick_date AS PICK_DATE,
        ptd.pick_detail_id AS PICK_DETAIL_ID,
        ptd.parent_id AS PARENT_ID,
        ptd.task_code AS TASK_CODE,
        ptd.item_code AS ITEM_CODE,
        i.item_name AS ITEM_NAME,
        ptd.mfg_date AS MFG_DATE,
        ptd.exp_date AS EXP_DATE,
        ptd.uom_id AS UOM_ID,
        u.uom_code AS UOM_CODE,
        u.uom_desc AS UOM_DESC,
        ptd.pack_uom_id AS PACK_UOM_ID,
        ISNULL(pu.uom_code, '') AS PACK_UOM_CODE,
        ISNULL(pu.uom_desc, '') AS PACK_UOM_DESC,
        ptd.qty AS QTY,
        ptd.confirm_qty AS CONFIRM_QTY,
        ptd.hz_group_code AS HZ_GROUP_CODE,
        ptd.home_zone_code AS HOME_ZONE_CODE,
        ptd.home_subzone_code AS HOME_SUBZONE_CODE,
        ptd.location_code AS LOCATION_CODE,
        ptd.item_status_id AS ITEM_STATUS_ID,
        its.item_status_code AS ITEM_STATUS_CODE,
        its.item_status_desc AS ITEM_STATUS_DESC,
        ptd.mhe_id AS MHE_ID,
        ptd.picker_id AS PICKER_ID,
        ISNULL(mh.mhe_code, '') AS MHE_CODE,
        ISNULL(mh.mhe_desc, '') AS MHE_DESC,
        ptd.inner_pack_uom_id AS INNER_PACK_UOM_ID,
        pta.box_code AS BOX_CODE,
        pta.pallet_no AS PALLET_NO,
        pta.batch_no AS BATCH_NO,
        pta.serial_no AS SERIAL_NO,
        pta.lot_no AS LOT_NO,
        pta.lpn_no AS LPN_NO,
        pta.color_code AS COLOR_CODE,
        ISNULL(lc.lov_desc, '') AS COLOR_DESC,
        pta.item_size AS ITEM_SIZE,
        ISNULL(ls.lov_desc, '') AS SIZE_DESC,
        l.pick_seq_no AS PICK_SEQ_NO,
        ptd.pick_trans_id AS PICK_TRANS_ID,
        ptd.li_id AS LI_ID,
        ptd.pick_remarks AS PICK_REMARKS,
        ISNULL(ur.display_name, '') AS PICKER_NAME,
        ISNULL(ia.item_brand, '') AS BRAND_CODE,
        ISNULL(ia.item_subbrand, '') AS SUBBRAND_CODE,
        (CASE ptd.pick_status
            WHEN 'PickNew' THEN 'NEW'
            WHEN 'PickAssign' THEN 'PICKER ASSIGNED'
            WHEN 'Alloc' THEN 'ALLOCATED'
            ELSE 'CONFIRMED'
        END) AS PICK_STATUS
    FROM
        ((((((((((((((((internal_wms.kit_pick_head p
        JOIN internal_wms.kit_pick_trans pt ON ((pt.pick_id = p.pick_id)))
        JOIN internal_wms.kit_pick_trans_details ptd ON ((ptd.pick_trans_id = pt.pick_trans_id)))
        JOIN internal_wms.kit_pick_trans_details_attributes pta ON ((ptd.pick_detail_id = pta.pick_detail_id)))
        JOIN internal_wms.kit_head k ON ((k.kit_id = pt.kit_id)))
        JOIN internal_wms.mst_company c ON ((c.company_id = p.company_id)))
        JOIN internal_wms.mst_warehouse w ON ((w.warehouse_id = p.warehouse_id)))
        JOIN internal_wms.mst_item i ON (((i.company_id = p.company_id)
            AND (i.item_code = ptd.item_code))))
        JOIN internal_wms.mst_uom u ON ((u.uom_id = ptd.uom_id)))
        JOIN internal_wms.mst_item_status its ON ((its.item_status_id = ptd.item_status_id)))
        JOIN internal_wms.mst_location l ON (((l.location_code = ptd.location_code)
            AND (l.company_id = p.company_id)
            AND (l.warehouse_id = p.warehouse_id))))
        LEFT JOIN internal_wms.ac_user ur ON ((ur.user_id = ptd.picker_id)))
        LEFT JOIN internal_wms.mst_uom pu ON ((pu.uom_id = ptd.pack_uom_id)))
        LEFT JOIN internal_wms.mst_mhe mh ON ((mh.mhe_id = ptd.mhe_id)))
        LEFT JOIN internal_wms.mst_lov lc ON (((lc.lov_code = pta.color_code)
            AND (lc.lov_filter = 'COLOR'))))
        LEFT JOIN internal_wms.mst_lov ls ON (((ls.lov_code = pta.item_size)
            AND (ls.lov_filter = 'ITEMSIZE'))))
        LEFT JOIN internal_wms.mst_item_attributes ia ON (((ia.company_id = i.company_id)
            AND (ia.item_code = i.item_code))))
    WHERE
        (ptd.pick_status <> 'PickCan')
-------------------------------------------------------------------------------------------------------------------------------------------
--9
--Done

alter VIEW internal_wms.vw_locinvty_goilcbe_report AS
    SELECT
        il.item_code AS ITEM_CODE,
        i.item_name AS ITEM_NAME,
        FORMAT(il.receipt_date, 'yyyy-MM-dd HH:mm:ss') AS RECEIPT_DATE,
        FORMAT(il.mfg_date, 'yyyy-MM-dd HH:mm:ss') AS MFG_DATE,
        FORMAT(il.exp_date, 'yyyy-MM-dd HH:mm:ss') AS EXP_DATE,
        il.onhand_qty AS ONHAND_QTY,
        il.reserved_qty AS RESERVED_QTY,
        il.available_qty AS AVAILABLE_QTY,
        il.onhold_qty AS ONHOLD_QTY,
        il.hz_group_code AS HZ_GROUP_CODE,
        il.home_zone_code AS HOME_ZONE_CODE,
        il.home_subzone_code AS HOME_SUBZONE_CODE,
        il.location_code AS LOCATION_CODE,
        il.remarks AS REMARKS,
        ild.item_mrp AS ITEM_MRP,
        ild.item_cost AS ITEM_COST,
        ild.box_code AS BOX_CODE,
        ild.pallet_no AS PALLET_NO,
        ild.batch_no AS BATCH_NO,
        ild.serial_no AS SERIAL_NO,
        ild.lot_no AS LOT_NO,
        ild.lpn_no AS LPN_NO,
        u.uom_code AS UOM_CODE,
        u.uom_desc AS UOM_DESC,
        its.item_status_code AS ITEM_STATUS_CODE,
        its.item_status_desc AS ITEM_STATUS_DESC,
        ISNULL(litu.uom_code, '') AS UOM,
        ISNULL((pltiu.convertion_factor * litiu.convertion_factor),
                '0') AS PLT_QTY,
        (ISNULL(litiu.convertion_factor, 0) * il.onhand_qty) AS CON_QOH,
        (ISNULL(litiu.convertion_factor, 0) * il.available_qty) AS CON_AVAIL,
        i.item_volume AS ITEM_VOLUME,
        (il.onhand_qty / ISNULL(litiu.convertion_factor, 0)) AS CASEQTY,
        (il.onhand_qty / ISNULL(litiu.convertion_factor, 0)) AS ACASEQTY,
        ig.item_group_code AS ITEM_GROUP_CODE,
        ig.item_group_name AS ITEM_GROUP_NAME,
        ic.category_code AS CATEGORY_CODE,
        ic.category_name AS CATEGORY_NAME,
        l.started_cycle_count AS STARTED_CYCLE_COUNT,
        ISNULL(ia.item_brand, '') AS BRAND_CODE,
        ISNULL(ia.item_subbrand, '') AS SUBBRAND_CODE,
        ISNULL(g.grn_code, '') AS GRN_CODE,
        ISNULL(s.supplier_code, '') AS SUPPLIER_CODE,
        ISNULL(s.supplier_name, '') AS SUPPLIER_NAME,
        il.company_id AS COMPANY_ID,
        il.warehouse_id AS WAREHOUSE_ID,
        uwm.user_id AS USER_ID
    FROM
        (((((((((((((((((internal_wms.invty_location_inventory il
        JOIN internal_wms.invty_location_inventory_detail ild ON ((ild.li_id = il.li_id)))
        JOIN internal_wms.invty_location_inventory_ibdetail ila ON ((ila.li_id = il.li_id)))
        JOIN internal_wms.mst_uom u ON ((u.uom_id = il.uom_id)))
        JOIN internal_wms.mst_item i ON (((i.item_code = il.item_code)
            AND (i.company_id = il.company_id))))
        JOIN internal_wms.mst_item_status its ON (((its.company_id = il.company_id)
            AND (its.item_status_id = il.item_status_id))))
        JOIN internal_wms.ac_user_warehouse_map uwm ON (((uwm.warehouse_id = il.warehouse_id)
            AND (uwm.user_id = 1)
            AND (uwm.active = 'A'))))
        JOIN internal_wms.mst_uom bu ON ((bu.uom_id = ild.base_uom_id)))
        JOIN internal_wms.mst_location l ON (((l.location_code = il.location_code)
            AND (il.warehouse_id = l.warehouse_id))))
        JOIN internal_wms.mst_item_uom pltiu ON (((pltiu.item_code = i.item_code)
            AND (i.company_id = pltiu.company_id)
            AND (pltiu.is_reporting_purpose = 'Y'))))
        JOIN internal_wms.mst_uom pltu ON (((pltu.uom_id = pltiu.uom_id)
            AND (pltu.uom_code = 'PLT')
            AND (pltu.company_id = pltiu.company_id))))
        JOIN internal_wms.mst_item_uom litiu ON (((litiu.item_code = i.item_code)
            AND (i.company_id = pltiu.company_id)
            AND (litiu.is_reporting_purpose = 'Y'))))
        JOIN internal_wms.mst_uom litu ON (((litu.uom_id = litiu.uom_id)
            AND (litu.uom_code IN ('LT' , 'KG'))
            AND (litu.company_id = litiu.company_id))))
        JOIN internal_wms.mst_item_group ig ON (((i.company_id = ig.company_id)
            AND (ig.item_group_id = i.item_group_id))))
        JOIN internal_wms.mst_item_category ic ON (((i.company_id = ic.company_id)
            AND (ic.item_category_id = i.item_category_id))))
        LEFT JOIN internal_wms.mst_item_attributes ia ON (((ia.company_id = i.company_id)
            AND (ia.item_code = i.item_code))))
        LEFT JOIN internal_wms.ib_grn g ON ((g.grn_number = ila.grn_number)))
        LEFT JOIN internal_wms.mst_supplier s ON (((s.supplier_id = g.supplier_id)
            AND (s.warehouse_id = g.warehouse_id))))
    WHERE
        ((l.location_type_id IN (1 , 2, 6, 7, 8, 9))
            AND (il.onhand_qty > 0))
---------------------------------------------------------------------------------------------------------------------------------------
--10
--Done
alter VIEW internal_wms.vw_locinvty_non_goilcbe_report AS
    SELECT
        i.item_name AS ITEM_NAME,
        FORMAT(il.receipt_date, 'yyyy-MM-dd HH:mm:ss') AS RECEIPT_DATE,
        FORMAT(il.mfg_date, 'yyyy-MM-dd HH:mm:ss') AS MFG_DATE,
        FORMAT(il.exp_date, 'yyyy-MM-dd HH:mm:ss') AS EXP_DATE,
        il.uom_id AS UOM_ID,
        il.pack_uom_id AS PACK_UOM_ID,
        il.onhand_qty AS ONHAND_QTY,
        il.reserved_qty AS RESERVED_QTY,
        il.available_qty AS AVAILABLE_QTY,
        il.onhold_qty AS ONHOLD_QTY,
        il.hz_group_code AS HZ_GROUP_CODE,
        il.home_zone_code AS HOME_ZONE_CODE,
        il.home_subzone_code AS HOME_SUBZONE_CODE,
        il.location_code AS LOCATION_CODE,
        il.item_status_id AS ITEM_STATUS_ID,
        il.remarks AS REMARKS,
        ild.base_uom_id AS BASE_UOM_ID,
        ild.item_mrp AS ITEM_MRP,
        ild.item_cost AS ITEM_COST,
        ild.box_code AS BOX_CODE,
        ild.pallet_no AS PALLET_NO,
        ild.batch_no AS BATCH_NO,
        ild.serial_no AS SERIAL_NO,
        ild.lot_no AS LOT_NO,
        ild.lpn_no AS LPN_NO,
        ISNULL(ila.invoice_no, '') AS INVOICE_NO,
        (CASE
            WHEN ila.invoice_date IS NULL THEN ''
            ELSE FORMAT(ila.invoice_date, 'yyyy-MM-dd HH:mm:ss')
        END) AS INVOICE_DATE,
        ISNULL(ila.color_code, '') AS COLOR_CODE,
        ISNULL(ila.item_size, '') AS ITEM_SIZE,
        u.uom_code AS UOM_CODE,
        u.uom_desc AS UOM_DESC,
        ISNULL(pu.uom_code, '') AS PACK_UOM,
        its.item_status_code AS ITEM_STATUS_CODE,
        its.item_status_desc AS ITEM_STATUS_DESC,
        ISNULL(pu.uom_desc, '') AS PACK_UOM_DESC,
        bu.uom_code AS BASE_UOM,
        bu.uom_desc AS BASE_UOM_DESC,
        ISNULL(iu.convertion_factor, 0) AS CONVERTION_FACTOR,
        ig.item_group_code AS ITEM_GROUP_CODE,
        ig.item_group_name AS ITEM_GROUP_NAME,
        ic.category_code AS CATEGORY_CODE,
        ic.category_name AS CATEGORY_NAME,
        l.started_cycle_count AS STARTED_CYCLE_COUNT,
        ISNULL(ia.item_brand, '') AS BRAND_CODE,
        ISNULL(ia.item_subbrand, '') AS SUBBRAND_CODE,
        ISNULL(g.grn_code, '') AS GRN_CODE,
        IIF(((il.item_component_code IS NOT NULL)
                AND (il.item_component_code <> '')),
            il.item_component_code,
            il.item_code) AS ITEM_CODE,
        ISNULL(s.supplier_code, '') AS SUPPLIER_CODE,
        ISNULL(s.supplier_name, '') AS SUPPLIER_NAME,
        ISNULL(ia.upc_code, '') AS UPC_CODE,
        il.company_id AS COMPANY_ID,
        il.warehouse_id AS WAREHOUSE_ID,
        uwm.user_id AS USER_ID
    FROM
        (((((((((((((((internal_wms.invty_location_inventory il
        JOIN internal_wms.invty_location_inventory_detail ild ON ((ild.li_id = il.li_id)))
        JOIN internal_wms.invty_location_inventory_ibdetail ila ON ((ila.li_id = il.li_id)))
        JOIN internal_wms.mst_uom u ON ((u.uom_id = il.uom_id)))
        JOIN internal_wms.mst_item i ON (((i.item_code = il.item_code)
            AND (i.company_id = il.company_id))))
        JOIN internal_wms.mst_item_status its ON (((its.company_id = il.company_id)
            AND (its.item_status_id = il.item_status_id))))
        JOIN internal_wms.ac_user_warehouse_map uwm ON (((uwm.warehouse_id = il.warehouse_id)
            AND (uwm.active = 'A'))))
        JOIN internal_wms.mst_uom bu ON ((bu.uom_id = ild.base_uom_id)))
        JOIN internal_wms.mst_location l ON (((l.location_code = il.location_code)
            AND (il.warehouse_id = l.warehouse_id))))
        JOIN internal_wms.mst_item_group ig ON (((i.company_id = ig.company_id)
            AND (ig.item_group_id = i.item_group_id))))
        JOIN internal_wms.mst_item_category ic ON (((i.company_id = ic.company_id)
            AND (ic.item_category_id = i.item_category_id))))
        LEFT JOIN internal_wms.mst_uom pu ON ((pu.uom_id = il.pack_uom_id)))
        LEFT JOIN internal_wms.mst_item_uom iu ON (((iu.company_id = il.company_id)
            AND (iu.item_code = il.item_code)
            AND (iu.uom_id = il.uom_id)
            AND (iu.is_packing = 'N')
            AND (iu.is_reporting_purpose = 'N')
            AND (iu.active = 'A'))))
        LEFT JOIN internal_wms.mst_item_attributes ia ON (((ia.company_id = i.company_id)
            AND (ia.item_code = i.item_code))))
        LEFT JOIN internal_wms.ib_grn g ON ((g.grn_number = ila.grn_number)))
        LEFT JOIN internal_wms.mst_supplier s ON (((s.supplier_id = g.supplier_id)
            AND (s.warehouse_id = g.warehouse_id))))
    WHERE
        ((l.location_type_id IN (1 , 2, 6, 7, 8, 9))
            AND (il.onhand_qty > 0))
------------------------------------------------------------------------------------------------------------------------------------------
--11
--Done
CREATE VIEW internal_wms.vw_non_aging_report AS
    SELECT
        res.ITEM_CODE AS ITEM_CODE,
        res.ITEM_NAME AS ITEM_NAME,
        res.UOM_CODE AS UOM_CODE,
        res.UOM_DESC AS UOM_DESC,
        res.ITEM_STATUS_CODE AS ITEM_STATUS_CODE,
        res.ITEM_STATUS_DESC AS ITEM_STATUS_DESC,
        res.PACK_UOM AS PACK_UOM,
        res.PACK_UOM_DESC AS PACK_UOM_DESC,
        SUM(res.BUCKET_1) AS '0-30',
        SUM(res.BUCKET_2) AS '31-60',
        SUM(res.BUCKET_3) AS '61-90',
        SUM(res.BUCKET_4) AS '91-120',
        SUM(res.BUCKET_5) AS '121-180',
        SUM(res.BUCKET_6) AS MORE_THAN_180,
        res.USER_ID AS USER_ID,
        res.COMPANY_ID AS COMPANY_ID,
        res.WAREHOUSE_ID AS WAREHOUSE_ID
    FROM
        (SELECT
            i.item_name AS ITEM_NAME,
                u.uom_code AS UOM_CODE,
                u.uom_desc AS UOM_DESC,
                its.item_status_code AS ITEM_STATUS_CODE,
                its.item_status_desc AS ITEM_STATUS_DESC,
                ISNULL(pu.uom_code, '') AS PACK_UOM,
                ISNULL(pu.uom_desc, '') AS PACK_UOM_DESC,
                IIF(((il.item_component_code IS NOT NULL)
                    AND (il.item_component_code <> '')), il.item_component_code, il.item_code) AS ITEM_CODE,
                (CASE
                    WHEN (DATEDIFF(d,GETDATE(),il.receipt_date) BETWEEN 0 AND 30) THEN il.onhand_qty
                    ELSE 0
                END) AS BUCKET_1,
                (CASE
                    WHEN (DATEDIFF(d,GETDATE(),il.receipt_date) BETWEEN 31 AND 60) THEN il.onhand_qty
                    ELSE 0
                END) AS BUCKET_2,
                (CASE
                    WHEN (DATEDIFF(d,GETDATE(),il.receipt_date) BETWEEN 61 AND 90) THEN il.onhand_qty
                    ELSE 0
                END) AS BUCKET_3,
                (CASE
                    WHEN (DATEDIFF(d,GETDATE(),il.receipt_date) BETWEEN 91 AND 120) THEN il.onhand_qty
                    ELSE 0
                END) AS BUCKET_4,
                (CASE
                    WHEN (DATEDIFF(d,GETDATE(),il.receipt_date) BETWEEN 121 AND 180) THEN il.onhand_qty
                    ELSE 0
                END) AS BUCKET_5,
                (CASE
                    WHEN (DATEDIFF(d,GETDATE(),il.receipt_date) > 180) THEN il.onhand_qty
                    ELSE 0
                END) AS BUCKET_6,
                uwm.user_id AS USER_ID,
                il.company_id AS COMPANY_ID,
                il.warehouse_id AS WAREHOUSE_ID
        FROM
            ((((((internal_wms.invty_location_inventory il
        JOIN internal_wms.mst_uom u ON ((u.uom_id = il.uom_id)))
        JOIN internal_wms.mst_item i ON (((i.item_code = il.item_code)
            AND (i.company_id = il.company_id))))
        JOIN internal_wms.mst_item_status its ON (((its.company_id = il.company_id)
            AND (its.item_status_id = il.item_status_id))))
        JOIN internal_wms.ac_user_warehouse_map uwm ON (((uwm.warehouse_id = il.warehouse_id)
            AND (uwm.active = 'A'))))
        JOIN internal_wms.mst_location l ON (((l.location_code = il.location_code)
            AND (il.warehouse_id = l.warehouse_id))))
        LEFT JOIN internal_wms.mst_uom pu ON ((pu.uom_id = il.pack_uom_id)))
        WHERE
            ((il.onhand_qty > 0)
                AND (l.location_type_id IN (1 , 2, 6, 7, 8, 9)))) res
    GROUP BY res.ITEM_CODE , res.ITEM_NAME , res.UOM_CODE , res.UOM_DESC , res.ITEM_STATUS_CODE , res.ITEM_STATUS_DESC , res.PACK_UOM , res.PACK_UOM_DESC, res.USER_ID,
        res.COMPANY_ID,
        res.WAREHOUSE_ID
---------------------------------------------------------------------------------------------------------------------------------------
--12
--done

alter VIEW internal_wms.vw_occupiedlocation_goilcbe_report AS
    SELECT
        il.item_code AS ITEM_CODE,
        i.item_name AS ITEM_NAME,
        FORMAT(il.receipt_date, 'yyyy-MM-dd HH:mm:ss') AS RECEIPT_DATE,
        FORMAT(il.mfg_date, 'yyyy-MM-dd HH:mm:ss') AS MFG_DATE,
        FORMAT(il.exp_date, 'yyyy-MM-dd HH:mm:ss') AS EXP_DATE,
        il.onhand_qty AS ONHAND_QTY,
        il.reserved_qty AS RESERVED_QTY,
        il.available_qty AS AVAILABLE_QTY,
        il.onhold_qty AS ONHOLD_QTY,
        il.hz_group_code AS HZ_GROUP_CODE,
        il.home_zone_code AS HOME_ZONE_CODE,
        il.home_subzone_code AS HOME_SUBZONE_CODE,
        il.location_code AS LOCATION_CODE,
        il.remarks AS REMARKS,
        ild.item_mrp AS ITEM_MRP,
        ild.item_cost AS ITEM_COST,
        ild.box_code AS BOX_CODE,
        ild.pallet_no AS PALLET_NO,
        ild.batch_no AS BATCH_NO,
        ild.serial_no AS SERIAL_NO,
        ild.lot_no AS LOT_NO,
        ild.lpn_no AS LPN_NO,
        u.uom_code AS UOM_CODE,
        u.uom_desc AS UOM_DESC,
        its.item_status_code AS ITEM_STATUS_CODE,
        its.item_status_desc AS ITEM_STATUS_DESC,
        ISNULL(litu.uom_code, '') AS UOM,
        ISNULL((pltiu.convertion_factor * litiu.convertion_factor),
                '0') AS PLT_QTY,
        (ISNULL(litiu.convertion_factor, 0) * il.onhand_qty) AS CON_QOH,
        (ISNULL(litiu.convertion_factor, 0) * il.available_qty) AS CON_AVAIL,
        i.item_volume AS ITEM_VOLUME,
        (il.onhand_qty / ISNULL(litiu.convertion_factor, 0)) AS CASEQTY,
        (il.onhand_qty / ISNULL(litiu.convertion_factor, 0)) AS ACASEQTY,
        ig.item_group_code AS ITEM_GROUP_CODE,
        ig.item_group_name AS ITEM_GROUP_NAME,
        ic.category_code AS CATEGORY_CODE,
        ic.category_name AS CATEGORY_NAME,
        l.started_cycle_count AS STARTED_CYCLE_COUNT,
        ISNULL(ia.item_brand, '') AS BRAND_CODE,
        ISNULL(ia.item_subbrand, '') AS SUBBRAND_CODE,
        uwm.user_id AS USER_ID,
        il.company_id AS COMPANY_ID,
        il.warehouse_id AS WAREHOUSE_ID
    FROM
        (((((((((((((((internal_wms.invty_location_inventory il
        JOIN internal_wms.invty_location_inventory_detail ild ON ((ild.li_id = il.li_id)))
        JOIN internal_wms.invty_location_inventory_ibdetail ila ON ((ila.li_id = il.li_id)))
        JOIN internal_wms.mst_uom u ON ((u.uom_id = il.uom_id)))
        JOIN internal_wms.mst_item i ON (((i.item_code = il.item_code)
            AND (i.company_id = il.company_id))))
        JOIN internal_wms.mst_item_status its ON (((its.company_id = il.company_id)
            AND (its.item_status_id = il.item_status_id))))
        JOIN internal_wms.ac_user_warehouse_map uwm ON (((uwm.warehouse_id = il.warehouse_id)
            AND (uwm.active = 'A'))))
        JOIN internal_wms.mst_uom bu ON ((bu.uom_id = ild.base_uom_id)))
        JOIN internal_wms.mst_location l ON (((l.location_code = il.location_code)
            AND (il.warehouse_id = l.warehouse_id))))
        JOIN internal_wms.mst_item_uom pltiu ON (((pltiu.item_code = i.item_code)
            AND (i.company_id = pltiu.company_id)
            AND (pltiu.is_reporting_purpose = 'Y'))))
        JOIN internal_wms.mst_uom pltu ON (((pltu.uom_id = pltiu.uom_id)
            AND (pltu.uom_code = 'PLT')
            AND (pltu.company_id = pltiu.company_id))))
        JOIN internal_wms.mst_item_uom litiu ON (((litiu.item_code = i.item_code)
            AND (i.company_id = pltiu.company_id)
            AND (litiu.is_reporting_purpose = 'Y'))))
        JOIN internal_wms.mst_uom litu ON (((litu.uom_id = litiu.uom_id)
            AND (litu.uom_code IN ('LT' , 'KG'))
            AND (litu.company_id = litiu.company_id))))
        JOIN internal_wms.mst_item_group ig ON (((i.company_id = ig.company_id)
            AND (ig.item_group_id = i.item_group_id))))
        JOIN internal_wms.mst_item_category ic ON (((i.company_id = ic.company_id)
            AND (ic.item_category_id = i.item_category_id))))
        LEFT JOIN internal_wms.mst_item_attributes ia ON (((ia.company_id = i.company_id)
            AND (ia.item_code = i.item_code))))
    WHERE
        (il.onhand_qty > 0)
-----------------------------------------------------------------------------------------------------------------------------------------
--13
--Done

alter VIEW internal_wms.vw_occupiedlocation_non_goilcbe_report AS
    SELECT
        il.item_code AS ITEM_CODE,
        i.item_name AS ITEM_NAME,
        FORMAT(il.receipt_date, 'yyyy-MM-dd HH:mm:ss') AS RECEIPT_DATE,
        FORMAT(il.mfg_date, 'yyyy-MM-dd HH:mm:ss') AS MFG_DATE,
        FORMAT(il.exp_date, 'yyyy-MM-dd HH:mm:ss') AS EXP_DATE,
        il.uom_id AS UOM_ID,
        il.pack_uom_id AS PACK_UOM_ID,
        il.onhand_qty AS ONHAND_QTY,
        il.reserved_qty AS RESERVED_QTY,
        il.available_qty AS AVAILABLE_QTY,
        il.onhold_qty AS ONHOLD_QTY,
        il.hz_group_code AS HZ_GROUP_CODE,
        il.home_zone_code AS HOME_ZONE_CODE,
        il.home_subzone_code AS HOME_SUBZONE_CODE,
        il.location_code AS LOCATION_CODE,
        il.item_status_id AS ITEM_STATUS_ID,
        il.remarks AS REMARKS,
        ild.base_uom_id AS BASE_UOM_ID,
        ild.item_mrp AS ITEM_MRP,
        ild.item_cost AS ITEM_COST,
        ild.box_code AS BOX_CODE,
        ild.pallet_no AS PALLET_NO,
        ild.batch_no AS BATCH_NO,
        ild.serial_no AS SERIAL_NO,
        ild.lot_no AS LOT_NO,
        ild.lpn_no AS LPN_NO,
        ISNULL(ila.invoice_no, '') AS INVOICE_NO,
        (CASE
            WHEN ila.invoice_date IS NULL THEN ''
            ELSE FORMAT(ila.invoice_date, 'yyyy-MM-dd HH:mm:ss')
        END) AS INVOICE_DATE,
        ISNULL(ila.color_code, '') AS COLOR_CODE,
        ISNULL(ila.item_size, '') AS ITEM_SIZE,
        u.uom_code AS UOM_CODE,
        u.uom_desc AS UOM_DESC,
        ISNULL(pu.uom_code, '') AS PACK_UOM,
        its.item_status_code AS ITEM_STATUS_CODE,
        its.item_status_desc AS ITEM_STATUS_DESC,
        ISNULL(pu.uom_desc, '') AS PACK_UOM_DESC,
        bu.uom_code AS BASE_UOM,
        bu.uom_desc AS BASE_UOM_DESC,
        ISNULL(iu.convertion_factor, 0) AS CONVERTION_FACTOR,
        ig.item_group_code AS ITEM_GROUP_CODE,
        ig.item_group_name AS ITEM_GROUP_NAME,
        ic.category_code AS CATEGORY_CODE,
        ic.category_name AS CATEGORY_NAME,
        l.started_cycle_count AS STARTED_CYCLE_COUNT,
        ISNULL(ia.item_brand, '') AS BRAND_CODE,
        ISNULL(ia.item_subbrand, '') AS SUBBRAND_CODE,
        uwm.user_id AS USER_ID,
        il.company_id AS COMPANY_ID,
        il.warehouse_id AS WAREHOUSE_ID
    FROM
        (((((((((((((internal_wms.invty_location_inventory il
        JOIN internal_wms.invty_location_inventory_detail ild ON ((ild.li_id = il.li_id)))
        JOIN internal_wms.invty_location_inventory_ibdetail ila ON ((ila.li_id = il.li_id)))
        JOIN internal_wms.mst_uom u ON ((u.uom_id = il.uom_id)))
        JOIN internal_wms.mst_item i ON (((i.item_code = il.item_code)
            AND (i.company_id = il.company_id))))
        JOIN internal_wms.mst_item_status its ON (((its.company_id = il.company_id)
            AND (its.item_status_id = il.item_status_id))))
        JOIN internal_wms.ac_user_warehouse_map uwm ON (((uwm.warehouse_id = il.warehouse_id)
            AND (uwm.active = 'A'))))
        JOIN internal_wms.mst_uom bu ON ((bu.uom_id = ild.base_uom_id)))
        JOIN internal_wms.mst_location l ON (((l.location_code = il.location_code)
            AND (il.warehouse_id = l.warehouse_id))))
        JOIN internal_wms.mst_item_group ig ON (((i.company_id = ig.company_id)
            AND (ig.item_group_id = i.item_group_id))))
        JOIN internal_wms.mst_item_category ic ON (((i.company_id = ic.company_id)
            AND (ic.item_category_id = i.item_category_id))))
        LEFT JOIN internal_wms.mst_uom pu ON ((pu.uom_id = il.pack_uom_id)))
        LEFT JOIN internal_wms.mst_item_uom iu ON (((iu.company_id = il.company_id)
            AND (iu.item_code = il.item_code)
            AND (iu.uom_id = il.uom_id))))
        LEFT JOIN internal_wms.mst_item_attributes ia ON (((ia.company_id = i.company_id)
            AND (ia.item_code = i.item_code)
            AND (iu.is_packing = 'N')
            AND (iu.is_reporting_purpose = 'N')
            AND (iu.active = 'A'))))
    WHERE
        (il.onhand_qty > 0)
-----------------------------------------------------------------------------------------------------------------------------------------
--14
--Done

CREATE VIEW internal_wms.vw_orderrpt_report AS
    SELECT
        o.order_code AS ORDER_CODE,
        o.order_reference AS ORDER_REFERENCE,
        o.order_date AS ORDER_DATE,
        c.customer_code AS CUSTOMER_CODE,
        c.customer_name AS CUSTOMER_NAME,
        od.order_detail_id AS ORDER_DETAIL_ID,
        od.order_id AS ORDER_ID,
        od.seq_no AS SEQ_NO,
        od.item_code AS ITEM_CODE,
        od.alt_item_code AS ALT_ITEM_CODE,
        od.uom_id AS UOM_ID,
        od.pack_uom_id AS PACK_UOM_ID,
        od.inner_pack_uom_id AS INNER_PACK_UOM_ID,
        od.item_status_id AS ITEM_STATUS_ID,
        od.qty AS QTY,
        od.order_item_ref AS ORDER_ITEM_REF,
        od.order_status AS ORDER_STATUS,
        od.bom_id AS BOM_ID,
        od.pending_qty AS PENDING_QTY,
        od.batch_no AS BATCH_NO,
        od.serial_no AS SERIAL_NO,
        od.lot_no AS LOT_NO,
        od.lpn_no AS LPN_NO,
        od.item_cost AS ITEM_COST,
        od.item_mrp AS ITEM_MRP,
        od.colour_code AS COLOUR_CODE,
        od.item_size AS ITEM_SIZE,
        od.spl_instructions AS SPL_INSTRUCTIONS,
        od.partial_shipment AS PARTIAL_SHIPMENT,
        od.merchant_code AS MERCHANT_CODE,
        od.track_seq_no AS TRACK_SEQ_NO,
        od.track_code AS TRACK_CODE,
        od.process_status AS PROCESS_STATUS,
        u.uom_desc AS UOM_DESC,
        u.uom_code AS UOM_CODE,
        i.item_name AS ITEM_NAME,
        o.order_type AS ORDER_TYPE,
        o.customer_id AS CUSTOMER_ID,
        o.priority AS PRIORITY,
        o.ship_to_id AS SHIP_TO_ID,
        o.req_arrival_date AS REQ_ARRIVAL_DATE,
        o.scheduled_arrival_date AS SCHEDULED_ARRIVAL_DATE,
        o.expected_ship_date AS EXPECTED_SHIP_DATE,
        o.order_stop_by_date AS ORDER_STOP_BY_DATE,
        o.route_id AS ROUTE_ID,
        o.transport_mode AS TRANSPORT_MODE,
        o.vehicle_type AS VEHICLE_TYPE,
        i.item_category_id AS ITEM_CATEGORY_ID,
        i.item_group_id AS ITEM_GROUP_ID,
        i.item_subgroup_id AS ITEM_SUBGROUP_ID,
        i.item_class AS ITEM_CLASS,
        i.movement_type AS MOVEMENT_TYPE,
        o.postal_code AS POSTAL_CODE,
        o.ba_id AS BA_ID,
        ISNULL(r.route_name, '') AS ROUTE_NAME,
        ISNULL(cy.city_code, '') AS CITY_CODE,
        ISNULL(cy.city_name, '') AS CITY_NAME,
        ISNULL(ia.item_brand, '') AS BRAND_CODE,
        ISNULL(ia.item_subbrand, '') AS SUBBRAND_CODE,
        its.item_status_code AS ITEM_STATUS_CODE,
        its.item_status_desc AS ITEM_STATUS_DESC,
        ISNULL(r.route_code, '') AS ROUTE_CODE,
        ISNULL(b.ba_code, '') AS BA_CODE,
        ISNULL(b.ba_name, '') AS BA_NAME,
        (CASE od.order_status
            WHEN 'OrdNew' THEN 'NEW'
            WHEN 'OrdProc' THEN 'ORDER PROCESSED'
            WHEN 'OrdCan' THEN 'CANCELLED'
            WHEN 'PickStart' THEN 'WAVE GENERATED'
            WHEN 'PickNew' THEN 'WAVE PROCESSED'
            ELSE ''
        END) AS ORDER_STATUS_DESC,
        o.invoice_no AS INVOICE_NO,
        uwm.user_id AS USER_ID
    FROM
        ((((((((((internal_wms.ob_order_details od
        JOIN internal_wms.ob_order_head o ON ((o.order_id = od.order_id)))
        JOIN internal_wms.mst_item i ON (((i.item_code = od.item_code)
            AND (i.company_id = o.company_id))))
        JOIN internal_wms.mst_uom u ON ((u.uom_id = od.uom_id)))
        JOIN internal_wms.mst_customer c ON (((c.customer_id = o.customer_id)
            AND (c.warehouse_id = o.warehouse_id))))
        JOIN internal_wms.ac_user_warehouse_map uwm ON (((uwm.warehouse_id = o.warehouse_id)
            AND (uwm.active = 'A'))))
        LEFT JOIN internal_wms.mst_city cy ON ((cy.city_id = o.ship_to_id)))
        JOIN internal_wms.mst_item_status its ON (((its.company_id = o.company_id)
            AND (its.item_status_id = od.item_status_id))))
        LEFT JOIN internal_wms.mst_route r ON (((r.route_id = o.route_id)
            AND (r.warehouse_id = o.warehouse_id))))
        LEFT JOIN internal_wms.mst_item_attributes ia ON (((ia.company_id = i.company_id)
            AND (ia.item_code = i.item_code))))
        LEFT JOIN internal_wms.mst_ba b ON ((b.ba_id = o.ba_id)))
----------------------------------------------------------------------------------------------------------------------------------------
--15
--Done

CREATE VIEW internal_wms.vw_orderstatus_report AS
    SELECT
        o.order_code AS ORDER_CODE,
        o.order_reference AS ORDER_REFERENCE,
        o.created_on AS ORDER_DATE,
        c.customer_code AS CUSTOMER_CODE,
        c.customer_name AS CUSTOMER_NAME,
        od.order_detail_id AS ORDER_DETAIL_ID,
        od.order_id AS ORDER_ID,
        od.seq_no AS SEQ_NO,
        od.item_code AS ITEM_CODE,
        od.alt_item_code AS ALT_ITEM_CODE,
        od.uom_id AS UOM_ID,
        od.pack_uom_id AS PACK_UOM_ID,
        od.inner_pack_uom_id AS INNER_PACK_UOM_ID,
        od.item_status_id AS ITEM_STATUS_ID,
        (CASE
            WHEN (osd.shipment_status = 'SHIPNEW') THEN osd.ship_qty
            WHEN (osd.shipment_status = 'SHIPCOMP') THEN osd.ship_qty
            WHEN (osd.shipment_status = 'SHIPCAN') THEN osd.ship_qty
            ELSE (CASE
                WHEN (opd.pack_status = 'PACKNEW') THEN opd.qty
                WHEN (opd.pack_status = 'PACKINIT') THEN opd.qty
                WHEN (opd.pack_status = 'PACKCAN') THEN opd.qty
                ELSE (CASE
                    WHEN (opt.pick_status = 'PICKCONF') THEN optd.confirm_qty
                    WHEN (opt.pick_status = 'SRTCONF') THEN optd.qty
                    WHEN (opt.pick_status = 'PICKASSIGN') THEN optd.qty
                    WHEN (opt.pick_status = 'PICKRELSE') THEN optd.qty
                    WHEN (optd.pick_status = 'PICKCAN') THEN optd.qty
                    WHEN (optd.pick_status = 'PICKNEW') THEN optd.qty
                    ELSE (CASE
                        WHEN (od.order_status = 'ORDNEW') THEN od.qty
                        WHEN (od.order_status = 'ORDPROC') THEN od.qty
                        WHEN (od.order_status = 'ORDCAN') THEN od.qty
                        WHEN (od.order_status = 'PICKSTART') THEN od.qty
                        WHEN (od.order_status = 'PickNew') THEN od.qty
                        ELSE ''
                    END)
                END)
            END)
        END) AS QTY,
        od.order_item_ref AS ORDER_ITEM_REF,
        od.order_status AS ORDER_STATUS,
        od.bom_id AS BOM_ID,
        od.batch_no AS BATCH_NO,
        od.serial_no AS SERIAL_NO,
        od.lot_no AS LOT_NO,
        od.lpn_no AS LPN_NO,
        od.item_cost AS ITEM_COST,
        od.item_mrp AS ITEM_MRP,
        od.colour_code AS COLOUR_CODE,
        od.item_size AS ITEM_SIZE,
        od.spl_instructions AS SPL_INSTRUCTIONS,
        od.partial_shipment AS PARTIAL_SHIPMENT,
        od.merchant_code AS MERCHANT_CODE,
        od.track_seq_no AS TRACK_SEQ_NO,
        od.track_code AS TRACK_CODE,
        od.process_status AS PROCESS_STATUS,
        u.uom_desc AS UOM_DESC,
        u.uom_code AS UOM_CODE,
        i.item_name AS ITEM_NAME,
        o.order_type AS ORDER_TYPE,
        o.customer_id AS CUSTOMER_ID,
        o.priority AS PRIORITY,
        o.ship_to_id AS SHIP_TO_ID,
        o.req_arrival_date AS REQ_ARRIVAL_DATE,
        o.scheduled_arrival_date AS SCHEDULED_ARRIVAL_DATE,
        o.expected_ship_date AS EXPECTED_SHIP_DATE,
        o.order_stop_by_date AS ORDER_STOP_BY_DATE,
        o.route_id AS ROUTE_ID,
        o.transport_mode AS TRANSPORT_MODE,
        o.vehicle_type AS VEHICLE_TYPE,
        i.item_category_id AS ITEM_CATEGORY_ID,
        i.item_group_id AS ITEM_GROUP_ID,
        i.item_subgroup_id AS ITEM_SUBGROUP_ID,
        i.item_class AS ITEM_CLASS,
        i.movement_type AS MOVEMENT_TYPE,
        o.postal_code AS POSTAL_CODE,
        o.ba_id AS BA_ID,
        ISNULL(r.route_name, '') AS ROUTE_NAME,
        ISNULL(cy.city_code, '') AS CITY_CODE,
        ISNULL(cy.city_name, '') AS CITY_NAME,
        ISNULL(ia.item_brand, '') AS BRAND_CODE,
        ISNULL(ia.item_subbrand, '') AS SUBBRAND_CODE,
        its.item_status_code AS ITEM_STATUS_CODE,
        its.item_status_desc AS ITEM_STATUS_DESC,
        ISNULL(r.route_code, '') AS ROUTE_CODE,
        ISNULL(b.ba_code, '') AS BA_CODE,
        ISNULL(b.ba_name, '') AS BA_NAME,
        (CASE
            WHEN (osd.shipment_status = 'SHIPNEW') THEN 'SHIPMENT CREATED'
            WHEN (osd.shipment_status = 'SHIPCOMP') THEN 'SHIPMENT COMPLETED'
            WHEN (osd.shipment_status = 'SHIPCAN') THEN 'SHIPMENT CANCELLED'
            ELSE (CASE
                WHEN (opd.pack_status = 'PACKNEW') THEN 'PACK COMPLETED'
                WHEN (opd.pack_status = 'PACKINIT') THEN 'PACK CREATED'
                WHEN (opd.pack_status = 'PACKCAN') THEN 'PACK CANCELLED'
                ELSE (CASE
                    WHEN (optd.pick_status = 'PICKCONF') THEN 'PICK CONFIRMED'
                    WHEN (optd.pick_status = 'SRTCONF') THEN 'SORTING CONFIRMED'
                    WHEN (optd.pick_status = 'PICKASSIGN') THEN 'PICK ASSIGNED'
                    WHEN (optd.pick_status = 'PICKRELSE') THEN 'PICK RELEASED'
                    WHEN (optd.pick_status = 'ALLOC') THEN 'PICK SPLITTED'
                    WHEN (optd.pick_status = 'PICKCAN') THEN 'PICK CANCELLED'
                    WHEN (optd.pick_status = 'PICKNEW') THEN 'WAVE PROCESSED'
                    ELSE (CASE
                        WHEN (od.order_status = 'ORDNEW') THEN 'NEW'
                        WHEN (od.order_status = 'ORDPROC') THEN 'ORDER PROCESSED'
                        WHEN (od.order_status = 'ORDCAN') THEN 'CANCELLED'
                        WHEN (od.order_status = 'PICKSTART') THEN 'WAVE GENERATED'
                        WHEN (od.order_status = 'PickNew') THEN 'WAVE PROCESSED'
                        ELSE ''
                    END)
                END)
            END)
        END) AS ORDER_STATUS_DESC,
        (CASE
            WHEN (osd.shipment_status = 'SHIPNEW') THEN osd.created_on
            WHEN (osd.shipment_status = 'SHIPCOMP') THEN osd.created_on
            WHEN (osd.shipment_status = 'SHIPCAN') THEN osd.created_on
            ELSE (CASE
                WHEN (opd.pack_status = 'PACKNEW') THEN opd.created_on
                WHEN (opd.pack_status = 'PACKINIT') THEN opd.created_on
                WHEN (opd.pack_status = 'PACKCAN') THEN opd.created_on
                ELSE (CASE
                    WHEN (optd.pick_status = 'PICKCONF') THEN optd.created_on
                    WHEN (optd.pick_status = 'SRTCONF') THEN optd.created_on
                    WHEN (optd.pick_status = 'PICKASSIGN') THEN optd.created_on
                    WHEN (optd.pick_status = 'PICKRELSE') THEN optd.created_on
                    WHEN (optd.pick_status = 'ALLOC') THEN optd.created_on
                    WHEN (optd.pick_status = 'PICKCAN') THEN optd.created_on
                    WHEN (optd.pick_status = 'PICKNEW') THEN optd.created_on
                    ELSE (CASE
                        WHEN (od.order_status = 'ORDNEW') THEN od.created_on
                        WHEN (od.order_status = 'ORDPROC') THEN od.created_on
                        WHEN (od.order_status = 'ORDCAN') THEN od.created_on
                        WHEN (od.order_status = 'PICKSTART') THEN od.created_on
                        WHEN (od.order_status = 'PickNew') THEN od.created_on
                        ELSE ''
                    END)
                END)
            END)
        END) AS ORDER_STATUS_DATE,
        o.invoice_no AS INVOICE_NO
    FROM
        (((((((((((((internal_wms.ob_order_details od
        JOIN internal_wms.ob_order_head o ON ((o.order_id = od.order_id)))
        JOIN internal_wms.mst_item i ON (((i.item_code = od.item_code)
            AND (i.company_id = o.company_id))))
        JOIN internal_wms.mst_uom u ON ((u.uom_id = od.uom_id)))
        JOIN internal_wms.mst_customer c ON (((c.customer_id = o.customer_id)
            AND (c.warehouse_id = o.warehouse_id))))
        LEFT JOIN internal_wms.mst_city cy ON ((cy.city_id = o.ship_to_id)))
        JOIN internal_wms.mst_item_status its ON (((its.company_id = o.company_id)
            AND (its.item_status_id = od.item_status_id))))
        LEFT JOIN internal_wms.mst_route r ON (((r.route_id = o.route_id)
            AND (r.warehouse_id = o.warehouse_id))))
        LEFT JOIN internal_wms.mst_item_attributes ia ON (((ia.company_id = i.company_id)
            AND (ia.item_code = i.item_code))))
        LEFT JOIN internal_wms.mst_ba b ON ((b.ba_id = o.ba_id)))
        LEFT JOIN internal_wms.ob_pick_trans opt ON (((opt.order_id = od.order_id)
            AND (opt.order_detail_id = od.order_detail_id))))
        LEFT JOIN internal_wms.ob_pick_trans_details optd ON ((optd.pick_trans_id = opt.pick_trans_id)))
        LEFT JOIN internal_wms.ob_pack_details opd ON (((opd.pick_detail_id = optd.pick_detail_id)
            AND (opd.pack_status <> 'PACKCAN'))))
        LEFT JOIN internal_wms.ob_shipment_details osd ON (((osd.order_id = od.order_id)
            AND (osd.order_detail_id = od.order_detail_id)
            AND (osd.shipment_status <> 'SHIPCAN')
            AND (optd.pick_detail_id = osd.pick_detail_id))))
----------------------------------------------------------------------------------------------------------------------------------------
--16
--Done

CREATE
   VIEW internal_wms.vw_packing_report AS
    SELECT 
        o.order_reference AS ORDER_REFERENCE,
        ph.pack_code AS PACK_CODE,
        ph.pack_id AS PACK_ID,
        ph.created_on AS CREATED_DATE,
        pd.item_code AS ITEM_CODE,
        ia.upc_code AS UPC_CODE,
        SUM(pd.qty) AS QTY,
        (CASE
            WHEN (pd.pack_status = 'PackNew') THEN 'PACK COMPLETED'
            ELSE 'PACK CREATED'
        END) AS STATUS
    FROM
        (((((internal_wms.ob_pick_trans pt
        JOIN internal_wms.ob_pick_trans_details ptd ON ((ptd.pick_trans_id = pt.pick_trans_id)))
        JOIN internal_wms.ob_order_head o ON ((o.order_id = pt.order_id)))
        JOIN internal_wms.ob_pack_details pd ON ((ptd.pick_detail_id = pd.pick_detail_id)))
        JOIN internal_wms.ob_pack_head ph ON ((ph.pack_id = pd.pack_id)))
        LEFT JOIN internal_wms.mst_item_attributes ia ON (((ia.company_id = ph.company_id)
            AND (ia.item_code = pd.item_code))))
    WHERE
        ((ph.pack_status IN ('PackInit' , 'PackNew'))
            AND (pd.pack_status IN ('PackInit' , 'PackNew')))
    GROUP BY ph.pack_id , pd.item_code , o.order_id, o.order_reference, ph.pack_code, ph.created_on, ia.upc_code, pd.pack_status
---------------------------------------------------------------------------------------------------------------------------------------------
--17
--Done
Alter
VIEW internal_wms.vw_pickr_goilcbe_report AS
    SELECT 
        oh.order_reference AS ORDER_REFERENCE,
        format(oh.order_date, 'yyyy-MM-dd HH:mm:ss') AS ORDER_DATE,
        cust.customer_code AS CUSTOMER_CODE,
        cust.customer_name AS CUSTOMER_NAME,
        oh.order_code AS ORDER_CODE,
        p.pick_code AS PICK_CODE,
        FORMAT(p.pick_date, 'yyyy-MM-dd HH:mm:ss') AS PICK_DATE,
        ptd.task_code AS TASK_CODE,
        ptd.item_code AS ITEM_CODE,
        i.item_name AS ITEM_NAME,
        FORMAT(ptd.mfg_date, 'yyyy-MM-dd HH:mm:ss') AS MFG_DATE,
        FORMAT(ptd.exp_date, 'yyyy-MM-dd HH:mm:ss') AS EXP_DATE,
        u.uom_code AS UOM_CODE,
        u.uom_desc AS UOM_DESC,
        ptd.qty AS QTY,
        ptd.confirm_qty AS CONFIRM_QTY,
        ptd.hz_group_code AS HZ_GROUP_CODE,
        ptd.home_zone_code AS HOME_ZONE_CODE,
        ptd.home_subzone_code AS HOME_SUBZONE_CODE,
        ptd.location_code AS LOCATION_CODE,
        its.item_status_code AS ITEM_STATUS_CODE,
        its.item_status_desc AS ITEM_STATUS_DESC,
        pta.box_code AS BOX_CODE,
        pta.pallet_no AS PALLET_NO,
        pta.batch_no AS BATCH_NO,
        pta.serial_no AS SERIAL_NO,
        pta.lot_no AS LOT_NO,
        pta.lpn_no AS LPN_NO,
        isnull((pltiu.convertion_factor * litiu.convertion_factor),
                '0') AS PLT_QTY,
        (isnull(litiu.convertion_factor, 0) * ptd.qty) AS CON_QTY,
        (isnull(litiu.convertion_factor, 0) * ptd.confirm_qty) AS CON_CONFIRM,
        (ptd.qty / isnull(litiu.convertion_factor, 0)) AS CASEQTY,
        (ptd.confirm_qty / isnull(litiu.convertion_factor, 0)) AS ACASEQTY,
        isnull(litu.uom_code, '') AS CON_UOM,
        (CASE ptd.pick_status
            WHEN 'PickNew' THEN 'NEW'
            WHEN 'PickAssign' THEN 'PICKER ASSIGNED'
            WHEN 'Alloc' THEN 'ALLOCATED'
            ELSE 'CONFIRMED'
        END) AS PICK_STATUS,
        isnull(pur.user_name, '') AS PICKER_NAME,
        p.company_id AS COMPANY_ID,
        p.warehouse_id AS WAREHOUSE_ID
    FROM
        ((((((((((((((((internal_wms.ob_pick_head p
        JOIN internal_wms.ob_pick_trans pt ON ((pt.pick_id = p.pick_id)))
        JOIN internal_wms.ob_pick_trans_details ptd ON ((ptd.pick_trans_id = pt.pick_trans_id)))
        JOIN internal_wms.ob_pick_trans_details_attributes pta ON ((ptd.pick_detail_id = pta.pick_detail_id)))
        JOIN internal_wms.ob_order_head oh ON ((oh.order_id = pt.order_id)))
        JOIN internal_wms.mst_company c ON ((c.company_id = p.company_id)))
        JOIN internal_wms.mst_warehouse w ON ((w.warehouse_id = p.warehouse_id)))
        JOIN internal_wms.mst_item i ON (((i.item_code = ptd.item_code)
            AND (i.company_id = p.company_id))))
        JOIN internal_wms.mst_uom u ON ((u.uom_id = ptd.uom_id)))
        JOIN internal_wms.mst_item_status its ON ((its.item_status_id = ptd.item_status_id)))
        JOIN internal_wms.mst_location l ON (((l.location_code = ptd.location_code)
            AND (l.company_id = p.company_id)
            AND (l.warehouse_id = p.warehouse_id))))
        JOIN internal_wms.mst_customer cust ON (((cust.customer_id = oh.customer_id)
            AND (cust.warehouse_id = oh.warehouse_id))))
        JOIN internal_wms.mst_item_uom pltiu ON (((pltiu.item_code = i.item_code)
            AND (i.company_id = pltiu.company_id)
            AND (pltiu.is_reporting_purpose = 'Y'))))
        JOIN internal_wms.mst_uom pltu ON (((pltu.uom_id = pltiu.uom_id)
            AND (pltu.uom_code = 'PLT')
            AND (pltu.company_id = pltiu.company_id))))
        JOIN internal_wms.mst_item_uom litiu ON (((litiu.item_code = i.item_code)
            AND (i.company_id = pltiu.company_id)
            AND (litiu.is_reporting_purpose = 'Y'))))
        JOIN internal_wms.mst_uom litu ON (((litu.uom_id = litiu.uom_id)
            AND (litu.uom_code IN ('LT' , 'KG'))
            AND (litu.company_id = litiu.company_id))))
        LEFT JOIN internal_wms.ac_user pur ON ((ptd.picker_id = pur.user_id)))
    WHERE
        (ptd.pick_status <> 'PickCan')
---------------	-------------------------------------------------------------------------------------------------------------------------------------
--18
--Done
alter
    VIEW internal_wms.vw_pickr_non__goilcbe_report AS
    SELECT 
        oh.order_reference AS ORDER_REFERENCE,
        FORMAT(oh.order_date, 'yyyy-MM-dd HH:mm:ss') AS ORDER_DATE,
        cust.customer_code AS CUSTOMER_CODE,
        cust.customer_name AS CUSTOMER_NAME,
        oh.order_code AS ORDER_CODE,
        p.pick_code AS PICK_CODE,
        FORMAT(p.pick_date, 'yyyy-MM-dd HH:mm:ss') AS PICK_DATE,
        ptd.task_code AS TASK_CODE,
        i.item_name AS ITEM_NAME,
        FORMAT(ptd.mfg_date, 'yyyy-MM-dd HH:mm:ss') AS MFG_DATE,
        FORMAT(ptd.exp_date, 'yyyy-MM-dd HH:mm:ss') AS EXP_DATE,
        u.uom_code AS UOM_CODE,
        u.uom_desc AS UOM_DESC,
        isnull(pu.uom_code, '') AS PACK_UOM_CODE,
        isnull(pu.uom_desc, '') AS PACK_UOM_DESC,
        ptd.qty AS QTY,
        ptd.confirm_qty AS CONFIRM_QTY,
        ptd.hz_group_code AS HZ_GROUP_CODE,
        ptd.home_zone_code AS HOME_ZONE_CODE,
        ptd.home_subzone_code AS HOME_SUBZONE_CODE,
        ptd.location_code AS LOCATION_CODE,
        its.item_status_code AS ITEM_STATUS_CODE,
        its.item_status_desc AS ITEM_STATUS_DESC,
        isnull(mh.mhe_code, '') AS MHE_CODE,
        isnull(mh.mhe_desc, '') AS MHE_DESC,
        pta.box_code AS BOX_CODE,
        pta.pallet_no AS PALLET_NO,
        pta.batch_no AS BATCH_NO,
        pta.serial_no AS SERIAL_NO,
        pta.lot_no AS LOT_NO,
        pta.lpn_no AS LPN_NO,
        pta.color_code AS COLOR_CODE,
        isnull(lc.lov_desc, '') AS COLOR_DESC,
        pta.item_size AS ITEM_SIZE,
        isnull(ls.lov_desc, '') AS SIZE_DESC,
        (CASE ptd.pick_status
            WHEN 'PickNew' THEN 'NEW'
            WHEN 'PickRelse' THEN 'PICK RELEASED'
            WHEN 'PickAssign' THEN 'PICKER ASSIGNED'
            WHEN 'Alloc' THEN 'ALLOCATED'
            WHEN 'ShipLabeled' THEN 'SHIP LABELED'
            WHEN 'ManifestComp' THEN 'MANIFESTED'
            ELSE 'CONFIRMED'
        END) AS PICK_STATUS,
        isnull(pur.user_name, '') AS PICKER_NAME,
        isnull(ia.item_brand, '') AS BRAND_CODE,
        isnull(ia.item_subbrand, '') AS SUBBRAND_CODE,
        iif(((ptd.item_component_code IS NOT NULL)
                AND (ptd.item_component_code <> '')),
            ptd.item_component_code,
            ptd.item_code) AS ITEM_CODE,
        p.company_id AS COMPANY_ID,
        p.warehouse_id AS WAREHOUSE_ID
    FROM
        (((((((((((((((((internal_wms.ob_pick_head p
        JOIN internal_wms.ob_pick_trans pt ON ((pt.pick_id = p.pick_id)))
        JOIN internal_wms.ob_pick_trans_details ptd ON ((ptd.pick_trans_id = pt.pick_trans_id)))
        JOIN internal_wms.ob_pick_trans_details_attributes pta ON ((ptd.pick_detail_id = pta.pick_detail_id)))
        JOIN internal_wms.ob_order_head oh ON ((oh.order_id = pt.order_id)))
        JOIN internal_wms.mst_company c ON ((c.company_id = p.company_id)))
        JOIN internal_wms.mst_warehouse w ON ((w.warehouse_id = p.warehouse_id)))
        JOIN internal_wms.mst_item i ON (((i.item_code = ptd.item_code)
            AND (i.company_id = p.company_id))))
        JOIN internal_wms.mst_uom u ON ((u.uom_id = ptd.uom_id)))
        JOIN internal_wms.mst_item_status its ON ((its.item_status_id = ptd.item_status_id)))
        JOIN internal_wms.mst_location l ON (((l.location_code = ptd.location_code)
            AND (l.company_id = p.company_id)
            AND (l.warehouse_id = p.warehouse_id))))
        JOIN internal_wms.mst_customer cust ON (((cust.customer_id = oh.customer_id)
            AND (cust.warehouse_id = oh.warehouse_id))))
        LEFT JOIN internal_wms.mst_uom pu ON ((pu.uom_id = ptd.pack_uom_id)))
        LEFT JOIN internal_wms.mst_mhe mh ON ((mh.mhe_id = ptd.mhe_id)))
        LEFT JOIN internal_wms.mst_lov lc ON (((lc.lov_code = pta.color_code)
            AND (lc.lov_filter = 'COLOR'))))
        LEFT JOIN internal_wms.mst_lov ls ON (((ls.lov_code = pta.item_size)
            AND (ls.lov_filter = 'ITEMSIZE'))))
        LEFT JOIN internal_wms.ac_user pur ON ((ptd.picker_id = pur.user_id)))
        LEFT JOIN internal_wms.mst_item_attributes ia ON (((ia.company_id = i.company_id)
            AND (ia.item_code = i.item_code))))
    WHERE
        (ptd.pick_status <> 'PickCan')
-----------------------------------------------------------------------------------------------------------------------------------------
--19
--Done
alter
VIEW internal_wms.vw_pnar_report AS
    SELECT 
        oh.order_reference AS ORDER_REFERENCE,
       FORMAT(oh.order_date, 'yyyy-MM-dd HH:mm:ss') AS ORDER_DATE,
        cust.customer_code AS CUSTOMER_CODE,
        cust.customer_name AS CUSTOMER_NAME,
        oh.order_code AS ORDER_CODE,
        p.pick_code AS PICK_CODE,
        format(p.pick_date, 'yyyy-MM-dd HH:mm:ss') AS PICK_DATE,
        i.item_name AS ITEM_NAME,
        i.item_code AS ITEM_CODE,
        its.item_status_code AS ITEM_STATUS_CODE,
        u.uom_code AS UOM_CODE,
        ord.qty AS QTY,
        (ord.qty - ptd.qty) AS CONFIRM_QTY,
        ptd.qty AS PNA_QTY,
        ptd.location_code AS LOCATION_CODE,
        pta.batch_no AS BATCH_NO,
        pta.serial_no AS SERIAL_NO,
        pta.lot_no AS LOT_NO,
        pta.lpn_no AS LPN_NO,
        (CASE ptd.pick_remarks
            WHEN 'PNA' THEN 'SHORT'
        END) AS PICK_STATUS,
        isnull(pur.user_name, '') AS PICKER_NAME,
        isnull(ptd.pick_remarks, '') AS REMARKS,
        p.company_id AS COMPANY_ID,
        p.warehouse_id AS WAREHOUSE_ID
    FROM
        ((((((((((((((((((internal_wms.ob_pick_head p
        JOIN internal_wms.ob_pick_trans pt ON ((pt.pick_id = p.pick_id)))
        JOIN internal_wms.ob_pick_trans_details ptd ON ((ptd.pick_trans_id = pt.pick_trans_id)))
        JOIN internal_wms.ob_pick_trans_details_attributes pta ON ((ptd.pick_detail_id = pta.pick_detail_id)))
        JOIN internal_wms.ob_order_head oh ON ((oh.order_id = pt.order_id)))
        JOIN internal_wms.ob_order_details ord ON (((ord.order_id = oh.order_id)
            AND (ord.order_status = 'PickNew'))))
        JOIN internal_wms.mst_company c ON ((c.company_id = p.company_id)))
        JOIN internal_wms.mst_warehouse w ON ((w.warehouse_id = p.warehouse_id)))
        JOIN internal_wms.mst_item i ON (((i.item_code = ptd.item_code)
            AND (i.company_id = p.company_id))))
        JOIN internal_wms.mst_uom u ON ((u.uom_id = ptd.uom_id)))
        JOIN internal_wms.mst_item_status its ON ((its.item_status_id = ptd.item_status_id)))
        JOIN internal_wms.mst_location l ON (((l.location_code = ptd.location_code)
            AND (l.company_id = p.company_id)
            AND (l.warehouse_id = p.warehouse_id))))
        JOIN internal_wms.mst_customer cust ON (((cust.customer_id = oh.customer_id)
            AND (cust.warehouse_id = oh.warehouse_id))))
        LEFT JOIN internal_wms.mst_uom pu ON ((pu.uom_id = ptd.pack_uom_id)))
        LEFT JOIN internal_wms.mst_mhe mh ON ((mh.mhe_id = ptd.mhe_id)))
        LEFT JOIN internal_wms.mst_lov lc ON (((lc.lov_code = pta.color_code)
            AND (lc.lov_filter = 'COLOR'))))
        LEFT JOIN internal_wms.mst_lov ls ON (((ls.lov_code = pta.item_size)
            AND (ls.lov_filter = 'ITEMSIZE'))))
        LEFT JOIN internal_wms.ac_user pur ON ((ptd.picker_id = pur.user_id)))
        LEFT JOIN internal_wms.mst_item_attributes ia ON (((ia.company_id = i.company_id)
            AND (ia.item_code = i.item_code))))
    WHERE
        ((ptd.pick_status = 'PickCan')
            AND (ptd.pick_remarks = 'PNA'))
    GROUP BY oh.order_id, oh.order_reference, oh.order_date, cust.customer_code, cust.customer_name, oh.order_code, p.pick_code, p.pick_date, i.item_name,
				i.item_code, its.item_status_code, u.uom_code, ord.qty, ptd.qty, ptd.location_code, pta.batch_no, pta.serial_no, pta.lot_no, pta.lpn_no,
				ptd.pick_remarks, pur.user_name, p.company_id, p.warehouse_id

-------------------------------------------------------------------------------------------------------------------------------------------
--20
--Done

alter
VIEW internal_wms.vw_pregrnrpt_no_report AS
    SELECT 
        g.pg_code AS PG_CODE,
        g.ibpg_type AS IBPG_TYPE,
        format(g.ibpg_date, 'yyyy-MM-dd HH:mm:ss') AS IBPG_DATE,
        g.supplier_order_no AS SUPPLIER_ORDER_NO,
        g.invoice_no AS INVOICE_NO,
        g.invoice_value AS INVOICE_VALUE,
        format(g.invoice_date, 'yyyy-MM-dd HH:mm:ss') AS INVOICE_DATE,
        g.vehicle_no AS VEHICLE_NO,
        g.dock_no AS DOCK_NO,
        format(g.created_on, 'yyyy-MM-dd HH:mm:ss') AS CREATED_ON,
        format(gd.ib_date, 'yyyy-MM-dd HH:mm:ss') AS IB_DATE,
        gd.ib_ref AS IB_REF,
        gd.item_code AS ITEM_CODE,
        u.uom_code AS UOM_CODE,
        u.uom_desc AS UOM_DESC,
        isnull(pu.uom_code, '') AS PACK_UOM,
        its.item_status_desc AS ITEM_STATUS_DESC,
        its.item_status_code AS ITEM_STATUS_CODE,
        isnull(pu.uom_desc, '') AS PACK_UOM_DESC,
        gd.ib_qty AS IB_QTY,
        gd.ib_pending_qty AS IB_PENDING_QTY,
        isnull(SUM(rgd.grn_qty), 0) AS RECEIVED_QTY,
        gd.batch_no AS BATCH_NO,
        gd.serial_no AS SERIAL_NO,
        gd.lot_no AS LOT_NO,
        gd.lpn_no AS LPN_NO,
        format(gd.mfg_date, 'yyyy-MM-dd HH:mm:ss') AS MFG_DATE,
        format(gd.exp_date, 'yyyy-MM-dd HH:mm:ss') AS EXP_DATE,
        gd.colour_code AS COLOUR_CODE,
        gd.item_size AS ITEM_SIZE,
        gd.item_cost AS ITEM_COST,
        gd.item_mrp AS ITEM_MRP,
        gd.remarks AS REMARKS,
        i.item_name AS ITEM_NAME,
        isnull(ia.item_brand, '') AS BRAND_CODE,
        isnull(ia.item_subbrand, '') AS SUBBRAND_CODE,
        uwm.user_id AS USER_ID,
        g.company_id AS COMPANY_ID,
        g.warehouse_id AS WAREHOUSE_ID
    FROM
        ((((((((internal_wms.ib_pre_grn g
        JOIN internal_wms.ib_pre_grn_details gd ON ((g.ibpg_number = gd.ibpg_number)))
        JOIN internal_wms.mst_uom u ON ((u.uom_id = gd.uom_id)))
        JOIN internal_wms.mst_item i ON (((i.item_code = gd.item_code)
            AND (i.company_id = g.company_id))))
        JOIN internal_wms.mst_item_status its ON (((its.company_id = g.company_id)
            AND (its.item_status_id = gd.item_status_id))))
        JOIN internal_wms.ac_user_warehouse_map uwm ON (((uwm.warehouse_id = g.warehouse_id)
            AND (uwm.active = 'A'))))
        LEFT JOIN internal_wms.ib_grn_details rgd ON (((rgd.ib_pre_grn_detail_id = gd.ib_pre_grn_detail_id)
            AND (rgd.grn_status <> 'GrnCan'))))
        LEFT JOIN internal_wms.mst_uom pu ON ((pu.uom_id = gd.pack_uom_id)))
        LEFT JOIN internal_wms.mst_item_attributes ia ON (((ia.company_id = i.company_id)
            AND (ia.item_code = i.item_code))))
    WHERE
        (gd.ib_status <> 'Cancel')
    GROUP BY g.pg_code, g.ibpg_type, g.ibpg_date,  g.supplier_order_no, g.invoice_value, g.invoice_date, g.vehicle_no, g.dock_no, g.created_on, gd.ib_date,
			 gd.ib_ref, gd.item_code, u.uom_code, u.uom_desc, pu.uom_code, its.item_status_desc, its.item_status_code, pu.uom_desc, gd.ib_qty, gd.ib_pending_qty,
			 rgd.grn_qty, gd.batch_no, gd.serial_no, gd.lot_no, gd.lpn_no, gd.mfg_date, gd.exp_date, gd.colour_code, gd.item_size, gd.item_cost, gd.item_mrp,
			 gd.remarks, i.item_name, ia.item_brand, ia.item_subbrand, uwm.user_id, g.company_id, g.warehouse_id, g.invoice_no

--------------------------------------------------------------------------------------------------------------------------------------------
--21
--Done

alter
VIEW
internal_wms.vw_pregrnrpt_yes_report AS
    SELECT 
        g.pg_code AS PG_CODE,
        g.ibpg_type AS IBPG_TYPE,
        format(g.ibpg_date, 'yyyy-MM-dd HH:mm:ss') AS IBPG_DATE,
        g.supplier_order_no AS SUPPLIER_ORDER_NO,
        g.invoice_no AS INVOICE_NO,
        g.invoice_value AS INVOICE_VALUE,
        format(g.invoice_date, 'yyyy-MM-dd HH:mm:ss') AS INVOICE_DATE,
        g.vehicle_no AS VEHICLE_NO,
        g.dock_no AS DOCK_NO,
        format(g.created_on, 'yyyy-MM-dd HH:mm:ss') AS CREATED_ON,
        format(gd.ib_date, 'yyyy-MM-dd HH:mm:ss') AS IB_DATE,
        gd.ib_ref AS IB_REF,
        gd.item_code AS ITEM_CODE,
        u.uom_code AS UOM_CODE,
        u.uom_desc AS UOM_DESC,
        isnull(pu.uom_code, '') AS PACK_UOM,
        its.item_status_desc AS ITEM_STATUS_DESC,
        its.item_status_code AS ITEM_STATUS_CODE,
        isnull(pu.uom_desc, '') AS PACK_UOM_DESC,
        gd.ib_qty AS IB_QTY,
        gd.ib_pending_qty AS IB_PENDING_QTY,
        isnull(COUNT(DISTINCT rgd.lpn_no), 0) AS RECEIVED_QTY,
        gd.batch_no AS BATCH_NO,
        gd.serial_no AS SERIAL_NO,
        gd.lot_no AS LOT_NO,
        gd.lpn_no AS LPN_NO,
        format(gd.mfg_date, 'yyyy-MM-dd HH:mm:ss') AS MFG_DATE,
        format(gd.exp_date, 'yyyy-MM-dd HH:mm:ss') AS EXP_DATE,
        gd.colour_code AS COLOUR_CODE,
        gd.item_size AS ITEM_SIZE,
        gd.item_cost AS ITEM_COST,
        gd.item_mrp AS ITEM_MRP,
        gd.remarks AS REMARKS,
        i.item_name AS ITEM_NAME,
        isnull(ia.item_brand, '') AS BRAND_CODE,
        isnull(ia.item_subbrand, '') AS SUBBRAND_CODE,
        uwm.user_id AS USER_ID,
        g.company_id AS COMPANY_ID,
        g.warehouse_id AS WAREHOUSE_ID
    FROM
        ((((((((internal_wms.ib_pre_grn g
        JOIN internal_wms.ib_pre_grn_details gd ON ((g.ibpg_number = gd.ibpg_number)))
        JOIN internal_wms.mst_uom u ON ((u.uom_id = gd.uom_id)))
        JOIN internal_wms.mst_item i ON (((i.item_code = gd.item_code)
            AND (i.company_id = g.company_id))))
        JOIN internal_wms.mst_item_status its ON (((its.company_id = g.company_id)
            AND (its.item_status_id = gd.item_status_id))))
        JOIN internal_wms.ac_user_warehouse_map uwm ON (((uwm.warehouse_id = g.warehouse_id)
            AND (uwm.active = 'A'))))
        LEFT JOIN internal_wms.ib_grn_details rgd ON (((rgd.ib_pre_grn_detail_id = gd.ib_pre_grn_detail_id)
            AND (rgd.grn_status <> 'GrnCan'))))
        LEFT JOIN internal_wms.mst_uom pu ON ((pu.uom_id = gd.pack_uom_id)))
        LEFT JOIN internal_wms.mst_item_attributes ia ON (((ia.company_id = i.company_id)
            AND (ia.item_code = i.item_code))))
    WHERE
        (gd.ib_status <> 'Cancel')
	group by g.pg_code, g.ibpg_type, g.ibpg_date, g.supplier_order_no, g.invoice_no, g.invoice_value, g.invoice_date, g.vehicle_no, g.dock_no, g.created_on,
			 gd.ib_date, gd.ib_ref, gd.item_code, u.uom_code, u.uom_desc, pu.uom_code, its.item_status_desc, its.item_status_code, pu.uom_desc, gd.ib_qty,
			 gd.ib_pending_qty, rgd.lpn_no, gd.batch_no, gd.serial_no, gd.lot_no, gd.lpn_no, gd.mfg_date, gd.exp_date, gd.colour_code, gd.item_size, gd.item_cost,
			 gd.item_mrp, gd.remarks, i.item_name, ia.item_brand, ia.item_subbrand, uwm.user_id,  g.company_id, g.warehouse_id

-----------------------------------------------------------------------------------------------------------------------------------------
--22

create 
VIEW internal_wms.vw_put_goilcbe_report AS
    SELECT 
        g.grn_code AS GRN_CODE,
        g.grn_type AS GRN_TYPE,
        FORMAT(g.grn_date, 'yyyy-MM-dd HH:mm:ss') AS GRN_DATE,
        g.supplier_order_no AS SUPPLIER_ORDER_NO,
        g.invoice_no AS INVOICE_NO,
        g.invoice_value AS INVOICE_VALUE,
        FORMAT(g.invoice_date, 'yyyy-MM-dd HH:mm:ss') AS INVOICE_DATE,
        FORMAT(g.created_on, 'yyyy-MM-dd HH:mm:ss') AS CREATED_ON,
        FORMAT(gc.ib_date, 'yyyy-MM-dd HH:mm:ss') AS IB_DATE,
        gc.ib_ref AS IB_REF,
        u.uom_code AS UOM_CODE,
        u.uom_desc AS UOM_DESC,
        '' AS PACK_UOM,
        its.item_status_desc AS ITEM_STATUS_DESC,
        its.item_status_code AS ITEM_STATUS_CODE,
        '' AS PACK_UOM_DESC,
        ptd.qty AS QTY,
        ptd.confirm_qty AS CONFIRM_QTY,
        gc.pending_qty AS PENDING_QTY,
        gc.grn_status AS GRN_STATUS,
        gc.box_code AS BOX_CODE,
        gc.pallet_no AS PALLET_NO,
        gc.batch_no AS BATCH_NO,
        gc.serial_no AS SERIAL_NO,
        gc.lot_no AS LOT_NO,
        gc.lpn_no AS LPN_NO,
        FORMAT(gc.mfg_date, 'yyyy-MM-dd HH:mm:ss') AS MFG_DATE,
        FORMAT(gc.exp_date, 'yyyy-MM-dd HH:mm:ss') AS EXP_DATE,
        gc.colour_code AS COLOUR_CODE,
        gc.item_size AS ITEM_SIZE,
        gc.item_cost AS ITEM_COST,
        gc.item_mrp AS ITEM_MRP,
        ph.put_id AS PUT_ID,
        ph.put_code AS PUT_CODE,
        FORMAT(ph.put_date, 'yyyy-MM-dd HH:mm:ss') AS PUT_DATE,
        ptd.task_code AS TASK_CODE,
        ptd.hz_group_code AS HZ_GROUP_CODE,
        ptd.home_zone_code AS HOME_ZONE_CODE,
        ptd.home_subzone_code AS HOME_SUBZONE_CODE,
        ptd.location_code AS LOCATION_CODE,
        (CASE ptd.put_status
            WHEN 'PutNew' THEN 'NEW'
            WHEN 'PutAssign' THEN 'PUTTER ASSIGNED'
            WHEN 'Alloc' THEN 'ALLOCATED'
            ELSE 'CONFIRMED'
        END) AS PUT_STATUS,
        pur.user_name AS PUTTER_NAME,
        ISNULL(mh.mhe_code, '') AS MHE_CODE,
        i.item_name AS ITEM_NAME,
        ISNULL(litu.uom_code, '') AS UOM,
        ISNULL((pltiu.convertion_factor * litiu.convertion_factor),
                '0') AS PLT_QTY,
        (ISNULL(litiu.convertion_factor, 0) * ptd.qty) AS ACTUAL_QTY,
        (ptd.qty / ISNULL(litiu.convertion_factor, 0)) AS CASEQTY,
        i.pallet_ti AS PALLET_TI,
        i.pallet_hi AS PALLET_HI,
        i.item_volume AS ITEM_VOLUME,
        (CASE
            WHEN ptd.modified_on is null or (ptd.modified_on = '2000-01-01') then ''
            ELSE FORMAT(ptd.modified_on, 'dd-MM-yy HH:mm:ss')
        END) AS CONFIRM_DATE,
        ig.item_group_code AS ITEM_GROUP_CODE,
        ISNULL(ia.item_brand, '') AS BRAND_CODE,
        ISNULL(ia.item_subbrand, '') AS SUBBRAND_CODE,
        IIF(((gc.item_component_code IS NOT NULL)
                AND (gc.item_component_code <> '')),
            gc.item_component_code,
            gc.item_code) AS ITEM_CODE,
        g.company_id AS COMPANY_ID,
        g.warehouse_id AS WAREHOUSE_ID,
        uwm.user_id AS USER_ID
    FROM
        ((((((((((((((((internal_wms.ib_grn g
        JOIN internal_wms.ib_grn_confirmation gc ON ((g.grn_number = gc.grn_number)))
        JOIN internal_wms.mst_uom u ON ((u.uom_id = gc.uom_id)))
        JOIN internal_wms.mst_item i ON (((i.item_code = gc.item_code)
            AND (i.company_id = g.company_id))))
        JOIN internal_wms.mst_item_status its ON (((its.company_id = g.company_id)
            AND (its.item_status_id = gc.item_status_id))))
        JOIN internal_wms.ac_user_warehouse_map uwm ON (((uwm.warehouse_id = g.warehouse_id)
            AND (uwm.active = 'A'))))
        JOIN internal_wms.ib_put_trans pt ON ((pt.grn_confirmation_id = gc.grn_confirmation_id)))
        JOIN internal_wms.ib_put_head ph ON ((ph.put_id = pt.put_id)))
        JOIN internal_wms.ib_put_trans_details ptd ON ((ptd.put_trans_id = pt.put_trans_id)))
        JOIN internal_wms.mst_item_uom pltiu ON (((pltiu.item_code = i.item_code)
            AND (i.company_id = pltiu.company_id)
            AND (pltiu.is_reporting_purpose = 'Y'))))
        JOIN internal_wms.mst_uom pltu ON (((pltu.uom_id = pltiu.uom_id)
            AND (pltu.uom_code = 'PLT')
            AND (pltu.company_id = pltiu.company_id))))
        JOIN internal_wms.mst_item_uom litiu ON (((litiu.item_code = i.item_code)
            AND (i.company_id = pltiu.company_id)
            AND (litiu.is_reporting_purpose = 'Y'))))
        JOIN internal_wms.mst_uom litu ON (((litu.uom_id = litiu.uom_id)
            AND (litu.uom_code IN ('LT' , 'KG'))
            AND (litu.company_id = litiu.company_id))))
        JOIN internal_wms.mst_item_group ig ON (((i.company_id = ig.company_id)
            AND (ig.item_group_id = i.item_group_id))))
        LEFT JOIN internal_wms.mst_mhe mh ON ((mh.mhe_id = ptd.mhe_id)))
        LEFT JOIN internal_wms.ac_user pur ON ((ptd.putter_id = pur.user_id)))
        LEFT JOIN internal_wms.mst_item_attributes ia ON (((ia.company_id = i.company_id)
            AND (ia.item_code = i.item_code))))
    WHERE
        ((g.grn_status IN ('GrnNew' , 'GrnConf', 'PutStart'))
            AND (gc.grn_status <> 'GrnCan')
            AND (ptd.put_status <> 'PutCan'))



-------------------------------------------------------------------------------------------------------------------------------------------
--23
--Done

alter 
VIEW internal_wms.vw_put_non_goilcbe_report AS
    SELECT 
        g.grn_code AS GRN_CODE,
        g.grn_type AS GRN_TYPE,
        format(g.grn_date, 'yyyy-MM-dd HH:mm:ss') AS GRN_DATE,
        g.supplier_order_no AS SUPPLIER_ORDER_NO,
        g.invoice_no AS INVOICE_NO,
        g.invoice_value AS INVOICE_VALUE,
        format(g.invoice_date, 'yyyy-MM-dd HH:mm:ss') AS INVOICE_DATE,
        format(g.created_on, 'yyyy-MM-dd HH:mm:ss') AS CREATED_ON,
        format(gc.ib_date, 'yyyy-MM-dd HH:mm:ss') AS IB_DATE,
        gc.ib_ref AS IB_REF,
        u.uom_code AS UOM_CODE,
        u.uom_desc AS UOM_DESC,
        isnull(pu.uom_code, '') AS PACK_UOM,
        its.item_status_desc AS ITEM_STATUS_DESC,
        its.item_status_code AS ITEM_STATUS_CODE,
        isnull(pu.uom_desc, '') AS PACK_UOM_DESC,
        ptd.qty AS QTY,
        ptd.confirm_qty AS CONFIRM_QTY,
        gc.pending_qty AS PENDING_QTY,
        gc.grn_status AS GRN_STATUS,
        gc.box_code AS BOX_CODE,
        gc.pallet_no AS PALLET_NO,
        gc.batch_no AS BATCH_NO,
        gc.serial_no AS SERIAL_NO,
        gc.lot_no AS LOT_NO,
        gc.lpn_no AS LPN_NO,
        format(gc.mfg_date, 'yyyy-MM-dd HH:mm:ss') AS MFG_DATE,
        format(gc.exp_date, 'yyyy-MM-dd HH:mm:ss') AS EXP_DATE,
        gc.colour_code AS COLOUR_CODE,
        gc.item_size AS ITEM_SIZE,
        gc.item_cost AS ITEM_COST,
        gc.item_mrp AS ITEM_MRP,
        ph.put_id AS PUT_ID,
        ph.put_code AS PUT_CODE,
        format(ph.put_date, 'yyyy-MM-dd HH:mm:ss') AS PUT_DATE,
        ptd.task_code AS TASK_CODE,
        ptd.hz_group_code AS HZ_GROUP_CODE,
        ptd.home_zone_code AS HOME_ZONE_CODE,
        ptd.home_subzone_code AS HOME_SUBZONE_CODE,
        ptd.location_code AS LOCATION_CODE,
        (CASE ptd.put_status
            WHEN 'PutNew' THEN 'NEW'
            WHEN 'PutAssign' THEN 'PUTTER ASSIGNED'
            WHEN 'Alloc' THEN 'ALLOCATED'
            ELSE 'CONFIRMED'
        END) AS PUT_STATUS,
        pur.user_name AS PUTTER_NAME,
        isnull(mh.mhe_code, '') AS MHE_CODE,
        i.item_name AS ITEM_NAME,
        isnull(ia.item_brand, '') AS BRAND_CODE,
        isnull(ia.item_subbrand, '') AS SUBBRAND_CODE,
        IIF(((gc.item_component_code IS NOT NULL)
                AND (gc.item_component_code <> '')),
            gc.item_component_code,
            gc.item_code) AS ITEM_CODE,
        g.company_id AS COMPANY_ID,
        g.warehouse_id AS WAREHOUSE_ID,
        uwm.user_id AS USER_ID
    FROM
        ((((((((((((internal_wms.ib_grn g
        JOIN internal_wms.ib_grn_confirmation gc ON ((g.grn_number = gc.grn_number)))
        JOIN internal_wms.mst_uom u ON ((u.uom_id = gc.uom_id)))
        JOIN internal_wms.mst_item i ON (((i.item_code = gc.item_code)
            AND (i.company_id = g.company_id))))
        JOIN internal_wms.mst_item_status its ON (((its.company_id = g.company_id)
            AND (its.item_status_id = gc.item_status_id))))
        JOIN internal_wms.ac_user_warehouse_map uwm ON (((uwm.warehouse_id = g.warehouse_id)
            AND (uwm.active = 'A'))))
        JOIN internal_wms.ib_put_trans pt ON ((pt.grn_confirmation_id = gc.grn_confirmation_id)))
        JOIN internal_wms.ib_put_head ph ON ((ph.put_id = pt.put_id)))
        JOIN internal_wms.ib_put_trans_details ptd ON ((ptd.put_trans_id = pt.put_trans_id)))
        LEFT JOIN internal_wms.mst_uom pu ON ((pu.uom_id = gc.pack_uom_id)))
        LEFT JOIN internal_wms.mst_mhe mh ON ((mh.mhe_id = ptd.mhe_id)))
        LEFT JOIN internal_wms.ac_user pur ON ((ptd.putter_id = pur.user_id)))
        LEFT JOIN internal_wms.mst_item_attributes ia ON (((ia.company_id = i.company_id)
            AND (ia.item_code = i.item_code))))
    WHERE
        ((g.grn_status IN ('GrnNew' , 'GrnConf', 'PutStart'))
            AND (gc.grn_status <> 'GrnCan')
            AND (ptd.put_status <> 'PutCan'))

------------------------------------------------------------------------------------------------------------------------------------------
--24
--Done

alter 
VIEW internal_wms.vw_recon_report AS
    SELECT 
        isi.item_code AS ITEM_CODE,
        isi.company_code AS COMPANY_CODE,
        isi.qty AS QTY,
        isi.country_code AS COUNTRY_CODE,
        isi.variant_code AS VARIANT_CODE,
        isi.location AS LOCATION,
        isi.bin AS BIN,
        isi.upc AS UPC,
        format(isi.created_on, 'yyyy-MM-dd HH:mm:ss') AS CREATED_ON,
        isi.wms_qty AS WMS_QTY,
        isi.variance_type AS VARIANCE_TYPE,
        isi.variance_qty AS VARIANCE_QTY,
        isi.product_description AS PRODUCT_DESCRIPTION,
        isi.product_type_code AS PRODUCT_TYPE_CODE,
        isi.product_type_description AS PRODUCT_TYPE_DESCRIPTION,
        isi.brand_code AS BRAND_CODE,
        isi.brand_description AS BRAND_DESCRIPTION,
        isi.product_group_code AS PRODUCT_GROUP_CODE,
        isi.product_group_description AS PRODUCT_GROUP_DESCRIPTION,
        isi.company_id AS COMPANY_ID,
        isi.warehouse_id AS WAREHOUSE_ID
    FROM
        invty_source_inventory isi
    ORDER BY isi.source_id DESC offset 0 rows 
----------------------------------------------------------------------------------------------------------------------------------------------
alter
VIEW internal_wms.vw_replen_report AS
    SELECT 
        p.pick_id AS PICK_ID,
        k.replen_id AS REPLEN_ID,
        k.replen_code AS REPLEN_CODE,
        k.replen_date AS REPLEN_DATE,
        p.pick_code AS PICK_CODE,
        p.company_id AS COMPANY_ID,
        c.company_code AS COMPANY_CODE,
        c.company_name AS COMPANY_NAME,
        p.warehouse_id AS WAREHOUSE_ID,
        w.warehouse_code AS WAREHOUSE_CODE,
        w.warehouse_name AS WAREHOUSE_NAME,
        p.pick_date AS PICK_DATE,
        ptd.pick_detail_id AS PICK_DETAIL_ID,
        ptd.parent_id AS PARENT_ID,
        ptd.task_code AS TASK_CODE,
        ptd.put_task_code AS PUT_TASK_CODE,
        ptd.item_code AS ITEM_CODE,
        i.item_name AS ITEM_NAME,
        ptd.mfg_date AS MFG_DATE,
        ptd.exp_date AS EXP_DATE,
        ptd.uom_id AS UOM_ID,
        u.uom_code AS UOM_CODE,
        u.uom_desc AS UOM_DESC,
        ptd.pack_uom_id AS PACK_UOM_ID,
        isnull(pu.uom_code, '') AS PACK_UOM_CODE,
        isnull(pu.uom_desc, '') AS PACK_UOM_DESC,
        ptd.qty AS QTY,
        ptd.confirm_qty AS CONFIRM_QTY,
        ptd.hz_group_code AS HZ_GROUP_CODE,
        ptd.home_zone_code AS HOME_ZONE_CODE,
        ptd.home_subzone_code AS HOME_SUBZONE_CODE,
        ptd.location_code AS LOCATION_CODE,
        rd.hz_group_code AS PF_HZ_GROUP_CODE,
        rd.home_zone_code AS PF_HOME_ZONE_CODE,
        rd.home_subzone_code AS PF_HOME_SUBZONE_CODE,
        rd.location_code AS PF_LOCATION_CODE,
        ptd.item_status_id AS ITEM_STATUS_ID,
        its.item_status_code AS ITEM_STATUS_CODE,
        its.item_status_desc AS ITEM_STATUS_DESC,
        ptd.mhe_id AS MHE_ID,
        ptd.picker_id AS PICKER_ID,
        ptd.putter_id AS PUTTER_ID,
        isnull(mh.mhe_code, '') AS MHE_CODE,
        isnull(mh.mhe_desc, '') AS MHE_DESC,
        ptd.inner_pack_uom_id AS INNER_PACK_UOM_ID,
        pta.box_code AS BOX_CODE,
        pta.pallet_no AS PALLET_NO,
        pta.batch_no AS BATCH_NO,
        pta.serial_no AS SERIAL_NO,
        pta.lot_no AS LOT_NO,
        pta.lpn_no AS LPN_NO,
        pta.color_code AS COLOR_CODE,
        isnull(lc.lov_desc, '') AS COLOR_DESC,
        pta.item_size AS ITEM_SIZE,
        isnull(ls.lov_desc, '') AS SIZE_DESC,
        l.pick_seq_no AS PICK_SEQ_NO,
        ptd.pick_trans_id AS PICK_TRANS_ID,
        ptd.li_id AS LI_ID,
        ptd.pick_remarks AS PICK_REMARKS,
        isnull(pkur.display_name, '') AS PICKER_NAME,
        isnull(ptur.display_name, '') AS PUTTER_NAME,
        isnull(ia.item_brand, '') AS BRAND_CODE,
        isnull(ia.item_subbrand, '') AS SUBBRAND_CODE,
        (CASE ptd.pick_status
            WHEN 'PickNew' THEN 'NEW'
            WHEN 'PickAssign' THEN 'PICKER ASSIGNED'
            WHEN 'PutAssign' THEN 'PUTTER ASSIGNED'
            WHEN 'Alloc' THEN 'PICKER ALLOCATED'
            WHEN 'PutAlloc' THEN 'PUTTER ALLOCATED'
            WHEN 'PickConf' THEN 'PICK CONFIRMED'
            WHEN 'PutConf' THEN 'PUT CONFIRMED'
            ELSE '-'
        END) AS PICK_STATUS
    FROM
        ((((((((((((((((((internal_wms.replen_pick_head p
        JOIN internal_wms.replen_pick_trans pt ON ((pt.pick_id = p.pick_id)))
        JOIN internal_wms.replen_pick_trans_details ptd ON ((ptd.pick_trans_id = pt.pick_trans_id)))
        JOIN internal_wms.replen_pick_trans_details_attributes pta ON ((ptd.pick_detail_id = pta.pick_detail_id)))
        JOIN internal_wms.replen_head k ON ((k.replen_id = pt.replen_id)))
        JOIN internal_wms.replen_details rd ON ((rd.replen_detail_id = pt.replen_detail_id)))
        JOIN internal_wms.mst_company c ON ((c.company_id = p.company_id)))
        JOIN internal_wms.mst_warehouse w ON ((w.warehouse_id = p.warehouse_id)))
        JOIN internal_wms.mst_item i ON (((i.company_id = p.company_id)
            AND (i.item_code = ptd.item_code))))
        JOIN internal_wms.mst_uom u ON ((u.uom_id = ptd.uom_id)))
        JOIN internal_wms.mst_item_status its ON ((its.item_status_id = ptd.item_status_id)))
        JOIN internal_wms.mst_location l ON (((l.location_code = ptd.location_code)
            AND (l.company_id = p.company_id)
            AND (l.warehouse_id = p.warehouse_id))))
        LEFT JOIN internal_wms.ac_user pkur ON ((pkur.user_id = ptd.picker_id)))
        LEFT JOIN internal_wms.ac_user ptur ON ((ptur.user_id = ptd.putter_id)))
        LEFT JOIN internal_wms.mst_uom pu ON ((pu.uom_id = ptd.pack_uom_id)))
        LEFT JOIN internal_wms.mst_mhe mh ON ((mh.mhe_id = ptd.mhe_id)))
        LEFT JOIN internal_wms.mst_lov lc ON (((lc.lov_code = pta.color_code)
            AND (lc.lov_filter = 'COLOR'))))
        LEFT JOIN internal_wms.mst_lov ls ON (((ls.lov_code = pta.item_size)
            AND (ls.lov_filter = 'ITEMSIZE'))))
        LEFT JOIN internal_wms.mst_item_attributes ia ON (((ia.company_id = i.company_id)
            AND (ia.item_code = i.item_code))))
    WHERE
        ((ptd.pick_status <> 'PickCan')
            OR (ptd.pick_status <> 'PutCan'))

--------------------------------------------------------------------------------------------------------------------------------------
--26
--Done

alter 
VIEW internal_wms.vw_ship_report AS
    SELECT 
        s.shipment_id AS SHIPMENT_ID,
        s.shipment_code AS SHIPMENT_CODE,
        s.company_id AS COMPANY_ID,
        s.warehouse_id AS WAREHOUSE_ID,
        s.shipment_date AS SHIPMENT_DATE,
        s.dispatch_date AS DISPATCH_DATE,
        s.shipment_status AS SHIPMENT_STATUS,
        s.route_id AS ROUTE_ID,
        s.vehicle_type AS VEHICLE_TYPE,
        s.vehicle_no AS VEHICLE_NO,
        s.dc_no AS DC_NO,
        s.lr_no AS LR_NO,
        s.lr_date AS LR_DATE,
        s.ba_id AS BA_ID,
        s.driver_name AS DRIVER_NAME,
        s.driver_mobile AS DRIVER_MOBILE,
        s.trip_id AS TRIP_ID,
        s.loaded_by AS LOADED_BY,
        s.manifest_no AS MANIFEST_NO,
        s.gross_weight AS GROSS_WEIGHT,
        s.remarks AS REMARKS,
        s.ref_1 AS REF_1,
        s.ref_2 AS REF_2,
        c.customer_id AS CUSTOMER_ID,
        c.customer_code AS CUSTOMER_CODE,
        c.customer_name AS CUSTOMER_NAME,
        isnull(r.route_code, '') AS ROUTE_CODE,
        isnull(r.route_name, '') AS ROUTE_NAME,
        isnull(b.ba_code, '') AS BA_CODE,
        isnull(b.ba_name, '') AS BA_NAME,
        its.item_status_code AS ITEM_STATUS_CODE,
        its.item_status_desc AS ITEM_STATUS_DESC,
        i.item_name AS ITEM_NAME,
        sd.ship_qty AS SHIP_QTY,
        sd.task_code AS TASK_CODE,
        p.pick_code AS PICK_CODE,
        u.uom_code AS UOM_CODE,
        u.uom_desc AS UOM_DESC,
        pta.box_code AS BOX_CODE,
        pta.pallet_no AS PALLET_NO,
        pta.batch_no AS BATCH_NO,
        pta.serial_no AS SERIAL_NO,
        pta.lot_no AS LOT_NO,
        pta.lpn_no AS LPN_NO,
        pta.color_code AS COLOR_CODE,
        isnull(lc.lov_desc, '') AS COLOR_DESC,
        pta.item_size AS ITEM_SIZE,
        isnull(ls.lov_desc, '') AS SIZE_DESC,
        o.order_code AS ORDER_CODE,
        o.order_reference AS ORDER_REFERENCE,
        sd.shipment_status AS LINE_SHIPMENT_STATUS,
        isnull(ur.display_name, '') AS USER_DISPLAY_NAME,
        isnull(ia.item_brand, '') AS BRAND_CODE,
        isnull(ia.item_subbrand, '') AS SUBBRAND_CODE,
        ptd.awb_number AS AWB_NUMBER,
        (CASE sd.shipment_status
            WHEN 'ShipNew' THEN 'NEW'
            WHEN 'ShipAssign' THEN 'SHIPPER ASSIGNED'
            WHEN 'Alloc' THEN 'ALLOCATED'
            ELSE 'CONFIRMED'
        END) AS LINE_SHIPMENT_STATUS_DESC,
        IIF(((ptd.item_component_code IS NOT NULL)
                AND (ptd.item_component_code <> '')),
            ptd.item_component_code,
            ptd.item_code) AS ITEM_CODE
    FROM
        ((((((((((((((((internal_wms.ob_shipment s
        JOIN internal_wms.ob_shipment_details sd ON ((sd.shipment_id = s.shipment_id)))
        JOIN internal_wms.ob_pick_head p ON ((p.pick_id = sd.pick_id)))
        JOIN internal_wms.ob_pick_trans pt ON ((pt.pick_id = p.pick_id)))
        JOIN internal_wms.ob_pick_trans_details ptd ON (((ptd.pick_trans_id = pt.pick_trans_id)
            AND (ptd.pick_detail_id = sd.pick_detail_id))))
        JOIN internal_wms.ob_pick_trans_details_attributes pta ON ((ptd.pick_detail_id = pta.pick_detail_id)))
        JOIN internal_wms.mst_item i ON (((i.item_code = sd.item_code)
            AND (i.company_id = s.company_id))))
        JOIN internal_wms.mst_uom u ON ((u.uom_id = sd.uom_id)))
        JOIN internal_wms.ob_order_head o ON ((o.order_id = pt.order_id)))
        JOIN internal_wms.mst_customer c ON ((c.customer_id = sd.customer_id)))
        JOIN internal_wms.mst_item_status its ON ((its.item_status_id = ptd.item_status_id)))
        LEFT JOIN internal_wms.mst_lov lc ON (((lc.lov_code = pta.color_code)
            AND (lc.lov_filter = 'COLOR'))))
        LEFT JOIN internal_wms.mst_lov ls ON (((ls.lov_code = pta.item_size)
            AND (ls.lov_filter = 'ITEMSIZE'))))
        LEFT JOIN internal_wms.mst_route r ON ((r.route_id = s.route_id)))
        LEFT JOIN internal_wms.mst_ba b ON ((b.ba_id = s.ba_id)))
        LEFT JOIN internal_wms.ac_user ur ON ((ur.user_id = sd.assigned_to)))
        LEFT JOIN internal_wms.mst_item_attributes ia ON (((ia.company_id = i.company_id)
            AND (ia.item_code = i.item_code))))
    WHERE
        ((sd.shipment_status <> 'ShipCan')
            AND (s.shipment_status <> 'ShipCan'))

------------------------------------------------------------------------------------------------------------------------------------
--27
--Done

CREATE 
VIEW internal_wms.vw_shipmentdl_report AS
    SELECT 
        o.ref_1 AS EXTERNAL_DOCUMENT_NO,
        o.order_id AS ORDER_ID,
        o.order_reference AS ORDER_REFERENCE,
        (CASE
            WHEN (o.order_type = 'OBCO') THEN 'SO'
            WHEN (o.order_type = 'OBST') THEN 'TO'
            ELSE 'PRO'
        END) AS ORDER_TYPE,
        c.customer_code AS CUSTOMER_CODE,
        o.ref_5 AS SERVICE_TYPE,
        CONCAT(ci.city_name, ' ', s.state_name) AS CITY,
        sdl.derivery_date AS DERIVERY_DATE,
        o.created_on AS ORDER_DATE,
        ms.created_on AS SHIPCONF_DATE,
        (CASE
            WHEN (ms.processed = 'N') THEN ''
            ELSE ms.modified_on
        END) AS SHIPCONF_SENT_DATE,
        o.invoice_no AS INVOICE_NO,
        (CASE
            WHEN (o.invoice_no = '') THEN ''
            ELSE o.modified_on
        END) AS INVOICE_DATE,
        c.customer_name AS CUSTOMER_NAME,
        od.hz_group_code AS HZ_GROUP_CODE,
        SUM(sd.ship_qty) AS SHIP_QTY,
        SUM(od.qty) AS ORDER_QTY,
        sdl.tracking_id AS AWB,
        sdl.created_on AS AWB_DATE,
        sdl.box_count AS BOX_COUNT,
        sdl.url AS SHIP_LABEL,
        (CASE
            WHEN (ba.ba_name = 'BD') THEN 'BlueDart'
            WHEN (ba.ba_name = 'CL') THEN 'CriticaLog'
            WHEN (ba.ba_name = 'EI') THEN 'Expeditors'
            WHEN (ba.ba_name = 'EcomEX') THEN 'EcomExpress'
            WHEN (ba.ba_name = 'SJ') THEN 'SpiceJet'
            WHEN (ba.ba_name = 'INDIA_POST') THEN 'India Post'
            ELSE o.ref_4
        END) AS BA_NAME
    FROM
        (((((((((internal_wms.ship_delivery sdl
        JOIN internal_wms.ob_order_head o ON ((o.order_id = sdl.order_id)))
        JOIN internal_wms.mst_customer c ON (((c.customer_id = o.customer_id)
            AND (c.warehouse_id = o.warehouse_id))))
        JOIN internal_wms.mst_address ad ON (((ad.map_id = c.customer_id)
            AND (ad.map_for = 'CU')
            AND (ad.active = 'A'))))
        JOIN internal_wms.mst_state s ON ((ad.state_id = s.state_id)))
        JOIN internal_wms.mst_city ci ON ((ad.city_id = ci.city_id)))
        JOIN internal_wms.ob_order_details od ON ((o.order_id = od.order_id)))
        LEFT JOIN internal_wms.ob_shipment_details sd ON (((od.order_id = sd.order_id)
            AND (sd.order_detail_id = od.order_detail_id))))
        LEFT JOIN internal_wms.msg_i_schedule ms ON (((ms.task_process_id = sd.shipment_id)
            AND (ms.task_type = 'SHPCONF'))))
        LEFT JOIN internal_wms.mst_ba ba ON ((((ba.ba_name = o.ref_4)
            OR (o.ref_4 LIKE CONCAT('%', ba.ba_name, '%')))
            AND (ba.ref_1 LIKE CONCAT('%', o.ref_3, '%'))
            AND (ba.ref_3 = o.ref_5)
            AND (ba.ref_4 LIKE CONVERT( VARCHAR(500) ,CONCAT('%', (CASE
            WHEN (o.special_instructions_1 = '05') THEN 'COD'
            ELSE 'PREPAID'
        END), '%') ))
            AND (ba.warehouse_id = o.warehouse_id)
            AND (ba.company_id = o.company_id))))
    WHERE
        (sdl.box_count IS NOT NULL)
    GROUP BY o.order_id, o.ref_1, o.order_reference, o.order_type, c.customer_code, o.ref_5, ci.city_name, s.state_name, sdl.derivery_date, o.created_on,
			 ms.created_on, ms.processed, ms.modified_on, o.invoice_no, o.modified_on, c.customer_name, od.hz_group_code, sd.ship_qty, od.qty, sdl.tracking_id,
			 sdl.created_on, sdl.box_count, sdl.url, ba.ba_name, o.ref_4



-----------------------------------------------------------------------------------------------------------------------------------------
--28
--Done

alter
VIEW internal_wms.vw_stkreloc_report AS
    SELECT 
        sr.relocation_code AS RELOCATION_CODE,
        sr.relocation_date AS RELOCATION_DATE,
        srd.relocation_id AS RELOCATION_ID,
        srd.tran_id AS TRAN_ID,
        srd.task_code AS TASK_CODE,
        srd.li_id AS LI_ID,
        srd.bom_id AS BOM_ID,
        srd.receipt_date AS RECEIPT_DATE,
        srd.mfg_date AS MFG_DATE,
        srd.exp_date AS EXP_DATE,
        srd.uom_id AS UOM_ID,
        srd.pack_uom_id AS PACK_UOM_ID,
        srd.qty AS RELOCATION_QTY,
        srd.hz_group_code AS HZ_GROUP_CODE,
        srd.home_zone_code AS HOME_ZONE_CODE,
        srd.home_subzone_code AS HOME_SUBZONE_CODE,
        srd.location_code AS LOCATION_CODE,
        srd.item_status_id AS ITEM_STATUS_ID,
        srd.to_hz_group_code AS TO_HZ_GROUP_CODE,
        srd.to_home_zone_code AS TO_HOME_ZONE_CODE,
        srd.to_home_subzone_code AS TO_HOME_SUBZONE_CODE,
        srd.to_location_code AS TO_LOCATION_CODE,
        srd.mhe_id AS MHE_ID,
        srd.adjuster_id AS ADJUSTER_ID,
        srd.remarks AS REMARKS,
        srd.item_mrp AS ITEM_MRP,
        srd.item_cost AS ITEM_COST,
        srd.box_code AS BOX_CODE,
        srd.pallet_no AS PALLET_NO,
        srd.batch_no AS BATCH_NO,
        srd.serial_no AS SERIAL_NO,
        srd.lot_no AS LOT_NO,
        srd.lpn_no AS LPN_NO,
        i.item_name AS ITEM_NAME,
        u.uom_code AS UOM_CODE,
        u.uom_desc AS UOM_DESC,
        isnull(pu.uom_code, '') AS PACK_UOM_CODE,
        isnull(pu.uom_desc, '') AS PACK_UOM_DESC,
        itc.category_code AS ITEM_CATEGORY_CODE,
        itg.item_group_code AS ITEM_GROUP_CODE,
        il.onhand_qty AS ONHAND_QTY,
        il.reserved_qty AS RESERVED_QTY,
        il.onhold_qty AS ONHOLD_QTY,
        il.available_qty AS AVAILABLE_QTY,
        isnull(ia.item_brand, '') AS BRAND_CODE,
        isnull(ia.item_subbrand, '') AS SUBBRAND_CODE,
        ia.colour_code AS COLOUR_CODE,
        ia.item_size AS ITEM_SIZE,
        isnull(its.item_status_code, '') AS ITEM_STATUS_CODE,
        isnull(its.item_status_desc, '') AS ITEM_STATUS_DESC,
        (CASE srd.relocation_status
            WHEN 'RelocProc' THEN 'NEW'
            WHEN 'RelocNew' THEN 'COMPLETED'
            WHEN 'RelocAssn' THEN 'ASSIGNED'
            ELSE 'CONFIRMED'
        END) AS RELOCATION_STATUS,
        IIF(((srd.item_component_code IS NOT NULL)
                AND (srd.item_component_code <> '')),
            srd.item_component_code,
            srd.item_code) AS ITEM_CODE
    FROM
        (((((((((internal_wms.invty_stock_relocation sr
        JOIN internal_wms.invty_stock_relocation_detail srd ON ((sr.relocation_id = srd.relocation_id)))
        JOIN internal_wms.invty_location_inventory il ON ((il.li_id = srd.li_id)))
        JOIN internal_wms.mst_item i ON (((i.item_code = srd.item_code)
            AND (i.company_id = sr.company_id))))
        JOIN internal_wms.mst_item_category itc ON (((itc.item_category_id = i.item_category_id)
            AND (itc.company_id = i.company_id))))
        JOIN internal_wms.mst_item_group itg ON (((itg.item_group_id = i.item_group_id)
            AND (itg.company_id = i.company_id))))
        JOIN internal_wms.mst_uom u ON (((u.uom_id = srd.uom_id)
            AND (u.company_id = sr.company_id))))
        JOIN internal_wms.mst_item_status its ON (((its.item_status_id = srd.item_status_id)
            AND (its.company_id = sr.company_id))))
        LEFT JOIN internal_wms.mst_item_attributes ia ON (((ia.company_id = i.company_id)
            AND (ia.item_code = i.item_code))))
        LEFT JOIN internal_wms.mst_uom pu ON (((pu.uom_id = srd.pack_uom_id)
            AND (pu.company_id = sr.company_id))))
    WHERE
        ((srd.relocation_status <> 'RelocCan')
            AND (sr.relocation_status <> 'RelocCan'))
------------------------------------------------------------------------------------------------------------------------------------------
--29
--Done
CREATE 
VIEW vw_suminvty_enbitemmulticomp_report AS
    SELECT 
        res.ITEM_CODE AS ITEM_CODE,
        res.ITEM_NAME AS ITEM_NAME,
        res.ITEM_STATUS_CODE AS ITEM_STATUS_CODE,
        SUM(res.QTY) AS QTY,
        res.UOM_CODE AS UOM_CODE,
        res.WAREHOUSE_CODE AS WAREHOUSE_CODE,
        res.WAREHOUSE_NAME AS WAREHOUSE_NAME,
        res.ITEM_GROUP_CODE AS ITEM_GROUP_CODE,
        res.ITEM_GROUP_NAME AS ITEM_GROUP_NAME,
        res.CATEGORY_CODE AS CATEGORY_CODE,
        res.CATEGORY_NAME AS CATEGORY_NAME,
        res.COMPANY_ID AS COMPANY_ID,
        res.WAREHOUSE_ID AS WAREHOUSE_ID
    FROM
        (SELECT 
            li.item_code AS ITEM_CODE,
                i.item_name AS ITEM_NAME,
                COUNT(DISTINCT lid.lpn_no) AS QTY,
                u.uom_code AS UOM_CODE,
                (CASE
                    WHEN (li.location_code = 'IBSTAGING') THEN 'RECEIVE'
                    ELSE its.item_status_code
                END) AS ITEM_STATUS_CODE,
                w.warehouse_code AS WAREHOUSE_CODE,
                w.warehouse_name AS WAREHOUSE_NAME,
                ig.item_group_code AS ITEM_GROUP_CODE,
                ig.item_group_name AS ITEM_GROUP_NAME,
                ic.category_code AS CATEGORY_CODE,
                ic.category_name AS CATEGORY_NAME,
                li.company_id AS COMPANY_ID,
                li.warehouse_id AS WAREHOUSE_ID
        FROM
            ((((((((internal_wms.invty_location_inventory li
        JOIN internal_wms.invty_location_inventory_detail lid ON ((lid.li_id = li.li_id)))
        JOIN internal_wms.mst_location l ON (((l.location_code = li.location_code)
            AND (l.warehouse_id = li.warehouse_id)
            AND (l.location_type_id IN (1 , 2, 6)))))
        JOIN internal_wms.mst_item i ON (((i.item_code = li.item_code)
            AND (i.company_id = li.company_id))))
        JOIN internal_wms.mst_item_status its ON ((its.item_status_id = li.item_status_id)))
        JOIN internal_wms.mst_uom u ON ((u.uom_id = li.uom_id)))
        JOIN internal_wms.mst_warehouse w ON ((w.warehouse_id = li.warehouse_id)))
        JOIN internal_wms.mst_item_group ig ON (((ig.company_id = i.company_id)
            AND (ig.item_group_id = i.item_group_id))))
        JOIN internal_wms.mst_item_category ic ON (((ic.company_id = i.company_id)
            AND (ic.item_category_id = i.item_category_id))))
        WHERE
            ((li.available_qty = 1)
                AND (its.item_status_code NOT IN ('LOST' , 'UNAVAILABLE', 'FOUND'))
                AND (li.adjustment_type <> 'CUSTOMER-RETURN'))
        GROUP BY li.item_code , (CASE
            WHEN (li.location_code = 'IBSTAGING') THEN 'RECEIVE'
            ELSE its.item_status_code
        END) UNION ALL SELECT 
            li.item_code AS ITEM_CODE,
                i.item_name AS ITEM_NAME,
                COUNT(DISTINCT lid.lpn_no) AS QTY,
                u.uom_code AS UOM_CODE,
                li.adjustment_type AS ITEM_STATUS_CODE,
                w.warehouse_code AS WAREHOUSE_CODE,
                w.warehouse_name AS WAREHOUSE_NAME,
                ig.item_group_code AS ITEM_GROUP_CODE,
                ig.item_group_name AS ITEM_GROUP_NAME,
                ic.category_code AS CATEGORY_CODE,
                ic.category_name AS CATEGORY_NAME,
                li.company_id AS COMPANY_ID,
                li.warehouse_id AS WAREHOUSE_ID
        FROM
            ((((((((internal_wms.invty_location_inventory li
        JOIN internal_wms.invty_location_inventory_detail lid ON ((lid.li_id = li.li_id)))
        JOIN internal_wms.mst_location l ON (((l.location_code = li.location_code)
            AND (l.warehouse_id = li.warehouse_id)
            AND (l.location_type_id IN (1 , 2, 6)))))
        JOIN internal_wms.mst_item i ON (((i.item_code = li.item_code)
            AND (i.company_id = li.company_id))))
        JOIN internal_wms.mst_item_status its ON ((its.item_status_id = li.item_status_id)))
        JOIN internal_wms.mst_uom u ON ((u.uom_id = li.uom_id)))
        JOIN internal_wms.mst_warehouse w ON ((w.warehouse_id = li.warehouse_id)))
        JOIN internal_wms.mst_item_group ig ON (((ig.company_id = i.company_id)
            AND (ig.item_group_id = i.item_group_id))))
        JOIN internal_wms.mst_item_category ic ON (((ic.company_id = i.company_id)
            AND (ic.item_category_id = i.item_category_id))))
        WHERE
            ((li.reserved_qty = 1)
                AND (its.item_status_code NOT IN ('LOST' , 'UNAVAILABLE', 'FOUND'))
                AND (li.adjustment_type IN ('CORDER-COMMITTED' , 'TRANSFER-COMMITTED', 'VRETURN-COMMITTED')))
        GROUP BY li.item_code , li.adjustment_type UNION ALL SELECT 
            li.item_code AS ITEM_CODE,
                i.item_name AS ITEM_NAME,
                COUNT(DISTINCT lid.lpn_no) AS QTY,
                u.uom_code AS UOM_CODE,
                (CASE
                    WHEN
                        ((li.location_code = 'IBSTAGING')
                            AND (its.item_status_code = 'PRIME'))
                    THEN
                        'CUSTOMER-RETURN'
                    ELSE its.item_status_code
                END) AS ITEM_STATUS_CODE,
                w.warehouse_code AS WAREHOUSE_CODE,
                w.warehouse_name AS WAREHOUSE_NAME,
                ig.item_group_code AS ITEM_GROUP_CODE,
                ig.item_group_name AS ITEM_GROUP_NAME,
                ic.category_code AS CATEGORY_CODE,
                ic.category_name AS CATEGORY_NAME,
                li.company_id AS COMPANY_ID,
                li.warehouse_id AS WAREHOUSE_ID
        FROM
            ((((((((internal_wms.invty_location_inventory li
        JOIN internal_wms.invty_location_inventory_detail lid ON ((lid.li_id = li.li_id)))
        JOIN internal_wms.mst_location l ON (((l.location_code = li.location_code)
            AND (l.warehouse_id = li.warehouse_id)
            AND (l.location_type_id IN (1 , 2, 6)))))
        JOIN internal_wms.mst_item i ON (((i.item_code = li.item_code)
            AND (i.company_id = li.company_id))))
        JOIN internal_wms.mst_item_status its ON ((its.item_status_id = li.item_status_id)))
        JOIN internal_wms.mst_uom u ON ((u.uom_id = li.uom_id)))
        JOIN internal_wms.mst_warehouse w ON ((w.warehouse_id = li.warehouse_id)))
        JOIN internal_wms.mst_item_group ig ON (((ig.company_id = i.company_id)
            AND (ig.item_group_id = i.item_group_id))))
        JOIN internal_wms.mst_item_category ic ON (((ic.company_id = i.company_id)
            AND (ic.item_category_id = i.item_category_id))))
        WHERE
            ((li.available_qty = 1)
                AND (its.item_status_code NOT IN ('LOST' , 'UNAVAILABLE', 'FOUND'))
                AND (li.adjustment_type = 'CUSTOMER-RETURN'))
        GROUP BY li.item_code , (CASE
            WHEN
                ((li.location_code = 'IBSTAGING')
                    AND (its.item_status_code = 'PRIME'))
            THEN
                'CUSTOMER-RETURN'
            ELSE its.item_status_code
        END)) res
    GROUP BY res.ITEM_CODE , res.ITEM_STATUS_CODE

----------------------------------------------------------------------------------------------------------------------------------------
--30
--Done

alter
VIEW internal_wms.vw_suminvty_non_enbitemmulticomp_report AS
    SELECT 
        il.item_code AS ITEM_CODE,
        i.item_name AS ITEM_NAME,
        il.uom_id AS UOM_ID,
        il.pack_uom_id AS PACK_UOM_ID,
        il.item_status_id AS ITEM_STATUS_ID,
        ild.item_mrp AS ITEM_MRP,
        ild.batch_no AS BATCH_NO,
        ild.serial_no AS SERIAL_NO,
        ild.lot_no AS LOT_NO,
        ild.lpn_no AS LPN_NO,
        u.uom_code AS UOM_CODE,
        u.uom_desc AS UOM_DESC,
        its.item_status_desc AS ITEM_STATUS_DESC,
        isnull(pu.uom_code, '') AS PACK_UOM,
        its.item_status_code AS ITEM_STATUS_CODE,
        isnull(pu.uom_desc, '') AS PACK_UOM_DESC,
        isnull(ia.item_brand, '') AS BRAND_CODE,
        isnull(ia.item_subbrand, '') AS SUBBRAND_CODE,
        SUM(il.onhand_qty) AS ONHAND_QTY,
        SUM(il.reserved_qty) AS RESERVED_QTY,
        SUM(il.available_qty) AS AVAILABLE_QTY,
        SUM(il.onhold_qty) AS ONHOLD_QTY,
        il.company_id AS COMPANY_ID,
        il.warehouse_id AS WAREHOUSE_ID,
        uwm.user_id AS USER_ID
    FROM
        (((((((((internal_wms.invty_location_inventory il
        JOIN internal_wms.invty_location_inventory_detail ild ON ((ild.li_id = il.li_id)))
        JOIN internal_wms.mst_uom u ON ((u.uom_id = il.uom_id)))
        JOIN internal_wms.mst_item i ON (((i.item_code = il.item_code)
            AND (i.company_id = il.company_id))))
        JOIN internal_wms.mst_item_status its ON (((its.company_id = il.company_id)
            AND (its.item_status_id = il.item_status_id))))
        JOIN internal_wms.ac_user_warehouse_map uwm ON (((uwm.warehouse_id = il.warehouse_id)
            AND (uwm.active = 'A'))))
        JOIN internal_wms.mst_uom bu ON ((bu.uom_id = ild.base_uom_id)))
        JOIN internal_wms.mst_location l ON (((l.location_code = il.location_code)
            AND (il.warehouse_id = l.warehouse_id))))
        LEFT JOIN internal_wms.mst_uom pu ON ((pu.uom_id = il.pack_uom_id)))
        LEFT JOIN internal_wms.mst_item_attributes ia ON (((ia.company_id = i.company_id)
            AND (ia.item_code = i.item_code))))
    WHERE
        ((l.location_type_id IN (1 , 2, 6, 7, 8, 9))
            AND (il.onhand_qty > 0))
    GROUP BY il.item_code, i.item_name, il.uom_id, il.pack_uom_id, il.item_status_id, ild.item_mrp, ild.batch_no, ild.serial_no, ild.lot_no, ild.lpn_no,
			 u.uom_code, u.uom_desc, its.item_status_desc, pu.uom_code, its.item_status_code, pu.uom_desc, ia.item_brand, ia.item_subbrand, il.onhand_qty,
			 il.reserved_qty, il.available_qty, il.onhold_qty, il.company_id, il.warehouse_id, uwm.user_id

-------------------------------------------------------------------------------------------------------------------------------------------

