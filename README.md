# thesis_scrollable_data
This project is a part of the thesis work done at IT-University of Copenhagen:<br />
Practical comparison of native and hybrid mobile app development<br />

In this project the app presents a table view where the user scrolls down a long list of images.<br />
**main:** The images are downloaded as batches of indicated numbers.<br />

The image sizes used in the project vary between 500 KB - 2.5 MB.<br />
To have a smoother scrolling experience Pagination and Lazy Loading is implemented.<br />

Some technology that are used in the app: <br />
Kingfisher: To download and cache the images.<br />
https://github.com/onevcat/Kingfisher<br />

**Firebase Storage:** To host the images.<br />
https://firebase.google.com/docs/storage<br />

**Firebase Performance:** Log points are stored in Firebase to measure certain download times.
https://firebase.google.com/docs/perf-mon <br />

Screenshot: <br />
<img src="https://user-images.githubusercontent.com/11957858/160172749-f48ade47-8bb4-4e1a-aebe-3613e8aeb6cf.png" width="300">
