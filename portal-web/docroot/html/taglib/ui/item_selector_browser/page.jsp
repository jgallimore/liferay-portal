<%--
/**
 * Copyright (c) 2000-present Liferay, Inc. All rights reserved.
 *
 * This library is free software; you can redistribute it and/or modify it under
 * the terms of the GNU Lesser General Public License as published by the Free
 * Software Foundation; either version 2.1 of the License, or (at your option)
 * any later version.
 *
 * This library is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more
 * details.
 */
--%>

<%@ include file="/html/taglib/ui/item_selector_browser/init.jsp" %>

<%
String displayStyle = GetterUtil.getString(request.getAttribute("liferay-ui:item-selector-browser:displayStyle"), "icon");
String idPrefix = GetterUtil.getString(request.getAttribute("liferay-ui:item-selector-browser:idPrefix"));
SearchContainer searchContainer = (SearchContainer)request.getAttribute("liferay-ui:item-selector-browser:searchContainer");
String tabName = GetterUtil.getString(request.getAttribute("liferay-ui:item-selector-browser:tabName"));
String uploadMessage = GetterUtil.getString(request.getAttribute("liferay-ui:item-selector-browser:uploadMessage"));
%>

<div class="taglib-item-selector-browser style-<%= displayStyle %>" id="<%= idPrefix %>ItemSelectorContainer">
	<aui:col cssClass='<%= displayStyle.equals("icon") ? "drop-zone preview-content" : "drop-zone" %>' width='<%= displayStyle.equals("icon") ? 25 : 100 %>'>
		<aui:a cssClass="browse-image btn btn-primary" href="javascript:;" id='<%= idPrefix + "SelectFile" %>' label="select-file" />

		<input id="<%= idPrefix %>InputFile" style="visibility: hidden; width: 0; height: 0" type="file" />

		<a href="" id="<%= idPrefix %>Image"></a>

		<div class="hide image-info">
			<dl>
				<dt><liferay-ui:message key="format" /></dt>
				<dd id="<%= idPrefix %>imageExtension"></dd>

				<dt><liferay-ui:message key="size" /></dt>
				<dd id="<%= idPrefix %>imageSize"></dd>

				<dt><liferay-ui:message key="name" /></dt>
				<dd id="<%= idPrefix %>imageName"></dd>
			</dl>
		</div>

		<p><%= uploadMessage %></p>
	</aui:col>

	<div class="drop-here-info">
		<div class="drop-here-indicator">
			<div class="drop-icons">
				<span aria-hidden="true" class="glyphicon glyphicon-picture"></span>
				<span aria-hidden="true" class="glyphicon glyphicon-picture"></span>
				<span aria-hidden="true" class="glyphicon glyphicon-picture"></span>
			</div>

			<div class="drop-text">
				<liferay-ui:message key="drop-files-here" />
			</div>
		</div>
	</div>

	<c:choose>
		<c:when test='<%= !displayStyle.equals("list") %>'>

			<%
			for (Object result : searchContainer.getResults()) {
				FileEntry fileEntry = (FileEntry)result;
				FileVersion latestFileVersion = fileEntry.getLatestFileVersion();

				String imagePreviewURL = DLUtil.getImagePreviewURL(fileEntry, themeDisplay);
				String imageURL = DLUtil.getPreviewURL(fileEntry, latestFileVersion, themeDisplay, StringPool.BLANK);
				String imageTitle = DLUtil.getTitleWithExtension(fileEntry);
			%>

				<c:choose>
					<c:when test='<%= displayStyle.equals("icon") %>'>
						<aui:col cssClass="preview-content" width="<%= 25 %>">
							<a class="item-preview" data-url="<%= HtmlUtil.escapeAttribute(imageURL) %>" href="<%= HtmlUtil.escapeHREF(imagePreviewURL) %>" title="<%= HtmlUtil.escapeAttribute(imageTitle) %>">
								<img align="left" src="<%= HtmlUtil.escapeAttribute(DLUtil.getPreviewURL(fileEntry, latestFileVersion, themeDisplay, "&imageThumbnail=2")) %>" />
							</a>

							<%@ include file="/html/taglib/ui/item_selector_browser/metadata_view.jspf" %>
						</aui:col>
					</c:when>
					<c:otherwise>
						<div class="list-content">
							<div class="thumbnail-container ">
								<img align="left" src="<%= DLUtil.getThumbnailSrc(fileEntry, themeDisplay) %>" />
							</div>

							<div style="float: left">
								<a class="item-preview" data-url="<%= HtmlUtil.escapeAttribute(imageURL) %>" href="<%= HtmlUtil.escapeHREF(imagePreviewURL) %>" title="<%= HtmlUtil.escapeAttribute(imageTitle) %>">
									<%= HtmlUtil.escape(imageTitle) %>
								</a>

								<%@ include file="/html/taglib/ui/item_selector_browser/metadata_view.jspf" %>

								<div>
									<small>
										<dl>
											<dt><liferay-ui:message key="status" />:</dt>
											<dd><aui:workflow-status showIcon="<%= false %>" showLabel="<%= false %>" status="<%= latestFileVersion.getStatus() %>" /></dd>

											<dt><liferay-ui:message key="modified" />:</dt>
											<dd><liferay-ui:message arguments="<%= new String[] {LanguageUtil.getTimeDescription(locale, System.currentTimeMillis() - fileEntry.getModifiedDate().getTime(), true), HtmlUtil.escape(fileEntry.getUserName())} %>" key="x-ago-by-x" translateArguments="<%= false %>" /></dd>
										</dl>
									</small>
								</div>
							</div>
						</div>
					</c:otherwise>
				</c:choose>

			<%
			}
			%>

			<liferay-ui:search-paginator searchContainer="<%= searchContainer %>" />
		</c:when>
		<c:otherwise>
			<div class="list-content">
				<liferay-ui:search-container
					searchContainer="<%= searchContainer %>"
					total="<%= searchContainer.getTotal() %>"
					var="listSearchContainer"
				>
					<liferay-ui:search-container-results
						results="<%= searchContainer.getResults() %>"
					/>

					<liferay-ui:search-container-row
						className="com.liferay.portal.kernel.repository.model.FileEntry"
						keyProperty="fileEntryId"
						modelVar="fileEntry"
					>

						<%
						FileVersion latestFileVersion = fileEntry.getLatestFileVersion();

						String imagePreviewURL = DLUtil.getImagePreviewURL(fileEntry, themeDisplay);
						String imageURL = DLUtil.getPreviewURL(fileEntry, latestFileVersion, themeDisplay, StringPool.BLANK);
						String imageTitle = DLUtil.getTitleWithExtension(fileEntry);

						String iconCssClass = DLUtil.getFileIconCssClass(fileEntry.getExtension());

						String author = fileEntry.getUserName();
						%>

						<liferay-ui:search-container-column-text name="title">
							<a class="item-preview" data-url="<%= HtmlUtil.escapeAttribute(imageURL) %>" href="<%= HtmlUtil.escapeHREF(imagePreviewURL) %>" title="<%= HtmlUtil.escapeAttribute(imageTitle) %>">
								<c:if test="<%= Validator.isNotNull(iconCssClass) %>">
									<i class="<%= iconCssClass %>"></i>
								</c:if>

								<span class="taglib-text">
									<%= HtmlUtil.escape(imageTitle) %>
								</span>
							</a>

							<%@ include file="/html/taglib/ui/item_selector_browser/metadata_view.jspf" %>
						</liferay-ui:search-container-column-text>

						<liferay-ui:search-container-column-text name="size" value="<%= TextFormatter.formatStorageSize(fileEntry.getSize(), locale) %>" />

						<liferay-ui:search-container-column-status name="status" status="<%= latestFileVersion.getStatus() %>" />

						<liferay-ui:search-container-column-text name="modified-date">
							<liferay-ui:message arguments="<%= new String[] {LanguageUtil.getTimeDescription(locale, System.currentTimeMillis() - fileEntry.getModifiedDate().getTime(), true), HtmlUtil.escape(author)} %>" key="x-ago-by-x" translateArguments="<%= false %>" />
						</liferay-ui:search-container-column-text>

					</liferay-ui:search-container-row>

					<liferay-ui:search-iterator />
				</liferay-ui:search-container>
			</div>
		</c:otherwise>
	</c:choose>
</div>

<div class="lfr-item-viewer" id="<%= idPrefix %>ItemViewerPreview"></div>
<div class="lfr-item-viewer" id="<%= idPrefix %>UploadImagePreview"></div>

<aui:script use="aui-component,liferay-item-viewer,liferay-item-selector-browser">
	var viewer = new A.LiferayItemViewer(
		{
			btnCloseCaption:'<%= UnicodeLanguageUtil.get(request, tabName) %>',
			links: '#<%= idPrefix %>ItemSelectorContainer a.item-preview',
		}
	).render('#<%= idPrefix %>ItemViewerPreview');

	var itemBrowser = new Liferay.ItemBrowser({
		browseImageId: 'SelectFile',
		inputFileId: 'InputFile',
		itemViewerCloseCaption: '<%= UnicodeLanguageUtil.get(request, tabName) %>',
		itemViewerContainer: 'UploadImagePreview',
		linkId: 'Image',
		namespace: '<%= idPrefix %>',
		rootNode: '#<%= idPrefix %>ItemSelectorContainer'
	});

</aui:script>