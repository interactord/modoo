import Foundation

enum ProfileDisplayModel {

  enum MediaContentType: Equatable {
    case grid
    case list
    case bookmark
  }

  struct MediaContentSectionItem: Equatable {

    // MARK: Lifecycle

    init() {
      headerItem = HeaderItem()
      cellItems = []
    }

    init(headerItem: HeaderItem = .init(), cellItems: [CellItem]) {
      self.headerItem = headerItem
      self.cellItems = cellItems
    }

    // MARK: Internal

    struct HeaderItem: Equatable {
      var type: MediaContentType  = .grid
    }

    struct CellItem: Equatable {
      let id: String
      let imageURL: String
    }

    var headerItem: HeaderItem

    var cellItems: [CellItem]

  }

  struct InformationSectionItem: Equatable {

    // MARK: Lifecycle

    init(headerItem: HeaderItem) {
      self.headerItem = headerItem
    }

    init(userRepositoryModel: UserRepositoryModel, socialRepositoryModel: UserSocialRepositoryModel, isFollowed: Bool = false, postCount: Int = 0) {
      let headerItem = HeaderItem(
        userName: userRepositoryModel.username,
        avatarImageURL: userRepositoryModel.profileImageURL,
        postCount: "\(postCount)",
        followingCount: "\(socialRepositoryModel.following)",
        followerCount: "\(socialRepositoryModel.followers)",
        bioDescription: "",
        isFollowed: isFollowed)

      self.init(headerItem: headerItem)
    }

    init() {
      headerItem = HeaderItem()
    }

    // MARK: Internal

    struct HeaderItem: Equatable {
      var userName = ""
      var avatarImageURL = ""
      var postCount = ""
      var followingCount = ""
      var followerCount = ""
      var bioDescription = ""
      var isFollowed = false
    }

    var headerItem: HeaderItem
    var cellItems: [String] = []

  }

  struct State: PresentableState {
    var informationSectionItemModel: ProfileInformationSectionItemModel
    var contentsSectionItemModel: ProfileContentSectionItemModel
    var isLoading: Bool
    var errorMessage: String

    static func initialState() -> Self {
      let informationSectionItemModel = ProfileInformationSectionItemModel()
      let contentsSectionItemModel = ProfileContentSectionItemModel()
      return State(
        informationSectionItemModel: informationSectionItemModel,
        contentsSectionItemModel: contentsSectionItemModel,
        isLoading: false,
        errorMessage: "")
    }
  }

}
